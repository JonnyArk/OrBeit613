"use strict";
/**
 * OrBeit AI Manager - Core AI Resource Controller
 *
 * @packageDocumentation
 * @module ai/ai_manager
 *
 * Central controller for all Google AI Ultra resources including
 * credit tracking, rate limiting, and service orchestration.
 * Manages 25,000 monthly AI credits for Flow and Whisk services.
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AIManager = exports.CREDIT_COSTS = void 0;
exports.getAIManager = getAIManager;
const firestore_1 = require("firebase-admin/firestore");
const logger = __importStar(require("firebase-functions/logger"));
/** Monthly credit allocation from Google AI Ultra plan */
const MONTHLY_CREDIT_LIMIT = 25000;
/** Credit costs per operation type */
exports.CREDIT_COSTS = {
    WHISK_IMAGE_SMALL: 5,
    WHISK_IMAGE_MEDIUM: 10,
    WHISK_IMAGE_LARGE: 25,
    FLOW_PIPELINE_SIMPLE: 2,
    FLOW_PIPELINE_COMPLEX: 8,
    FLOW_DISTILLATION: 4,
};
/**
 * AI Manager class for orchestrating all AI resources.
 *
 * @remarks
 * This class manages credit tracking, rate limiting, and provides
 * a unified interface for Whisk and Flow services.
 *
 * @example
 * const manager = new AIManager();
 * const canProceed = await manager.checkCredits(10);
 * if (canProceed.allowed) {
 *   await manager.logUsage('whisk', 10, 'badge_generation');
 * }
 */
class AIManager {
    db;
    usageCollection;
    /**
     * Creates a new AIManager instance.
     *
     * @param projectId - Firebase project ID (defaults to orbeit-613)
     */
    constructor(projectId = "orbeit-613") {
        this.db = (0, firestore_1.getFirestore)();
        this.usageCollection = "metadata/credits/usage";
        logger.info("AIManager initialized", { projectId });
    }
    /**
     * Checks if the requested credits are available within monthly limits.
     *
     * @param requestedCredits - Number of credits needed for the operation
     * @returns Promise resolving to credit check result with availability status
     *
     * @example
     * const check = await manager.checkCredits(10);
     * if (!check.allowed) {
     *   console.log(`Only ${check.remainingCredits} credits left this month`);
     * }
     */
    async checkCredits(requestedCredits) {
        try {
            const monthlyUsed = await this.getMonthlyUsage();
            const remainingCredits = MONTHLY_CREDIT_LIMIT - monthlyUsed;
            const allowed = requestedCredits <= remainingCredits;
            const result = {
                allowed,
                remainingCredits,
                monthlyUsed,
                percentageUsed: (monthlyUsed / MONTHLY_CREDIT_LIMIT) * 100,
            };
            if (!allowed) {
                logger.warn("Credit limit would be exceeded", {
                    requested: requestedCredits,
                    remaining: remainingCredits,
                    monthlyUsed,
                });
            }
            return result;
        }
        catch (error) {
            logger.error("Failed to check credits", { error });
            // Fail-safe: deny if we can't verify credits
            return {
                allowed: false,
                remainingCredits: 0,
                monthlyUsed: MONTHLY_CREDIT_LIMIT,
                percentageUsed: 100,
            };
        }
    }
    /**
     * Logs credit usage to Firestore for tracking and analytics.
     *
     * @param service - The AI service used (whisk or flow)
     * @param creditsUsed - Number of credits consumed
     * @param featureId - Identifier for the feature that used credits
     * @param userId - Optional user ID for per-user tracking
     * @param metadata - Optional additional metadata
     * @returns Promise resolving to the logged entry
     *
     * @throws Error if logging fails
     *
     * @example
     * await manager.logUsage('whisk', 10, 'avatar_generation', 'user123', {
     *   assetType: 'avatar',
     *   resolution: '512x512'
     * });
     */
    async logUsage(service, creditsUsed, featureId, userId, metadata) {
        const entry = {
            service,
            timestamp: firestore_1.FieldValue.serverTimestamp(),
            creditsUsed,
            featureId,
            userId,
            metadata,
        };
        try {
            await this.db.collection(this.usageCollection).add(entry);
            // Update monthly aggregate
            await this.updateMonthlyAggregate(creditsUsed);
            logger.info("Credit usage logged", {
                service,
                creditsUsed,
                featureId,
                userId,
            });
            return entry;
        }
        catch (error) {
            logger.error("Failed to log credit usage", { error, entry });
            throw new Error(`Failed to log credit usage: ${error}`);
        }
    }
    /**
     * Gets the total credit usage for the current month.
     *
     * @returns Promise resolving to total credits used this month
     */
    async getMonthlyUsage() {
        try {
            const now = new Date();
            const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
            const snapshot = await this.db
                .collection(this.usageCollection)
                .where("timestamp", ">=", monthStart)
                .get();
            let total = 0;
            snapshot.forEach((doc) => {
                const data = doc.data();
                total += data.creditsUsed || 0;
            });
            return total;
        }
        catch (error) {
            logger.error("Failed to get monthly usage", { error });
            return 0;
        }
    }
    /**
     * Updates the monthly aggregate counter atomically.
     *
     * @param creditsToAdd - Credits to add to the monthly total
     */
    async updateMonthlyAggregate(creditsToAdd) {
        const now = new Date();
        const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
        const aggregateRef = this.db.doc(`metadata/credits/monthly/${monthKey}`);
        await aggregateRef.set({
            totalUsed: firestore_1.FieldValue.increment(creditsToAdd),
            lastUpdated: firestore_1.FieldValue.serverTimestamp(),
            monthKey,
        }, { merge: true });
    }
    /**
     * Gets a summary of credit usage for analytics.
     *
     * @returns Promise resolving to usage summary object
     */
    async getUsageSummary() {
        const monthlyUsed = await this.getMonthlyUsage();
        const now = new Date();
        const daysInMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
        const dayOfMonth = now.getDate();
        const daysRemaining = daysInMonth - dayOfMonth;
        const dailyAverage = monthlyUsed / dayOfMonth;
        const remaining = MONTHLY_CREDIT_LIMIT - monthlyUsed;
        const estimatedDaysRemaining = dailyAverage > 0 ? Math.floor(remaining / dailyAverage) : daysRemaining;
        return {
            monthlyUsed,
            monthlyLimit: MONTHLY_CREDIT_LIMIT,
            remaining,
            percentageUsed: (monthlyUsed / MONTHLY_CREDIT_LIMIT) * 100,
            estimatedDaysRemaining: Math.min(estimatedDaysRemaining, daysRemaining),
        };
    }
}
exports.AIManager = AIManager;
/** Singleton instance for global access */
let _instance = null;
/**
 * Gets the singleton AIManager instance.
 *
 * @returns The global AIManager instance
 */
function getAIManager() {
    if (!_instance) {
        _instance = new AIManager();
    }
    return _instance;
}
//# sourceMappingURL=ai_manager.js.map