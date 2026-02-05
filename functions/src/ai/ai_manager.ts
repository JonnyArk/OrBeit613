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

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

/** Monthly credit allocation from Google AI Ultra plan */
const MONTHLY_CREDIT_LIMIT = 25000;

/** Credit costs per operation type */
export const CREDIT_COSTS = {
    WHISK_IMAGE_SMALL: 5,
    WHISK_IMAGE_MEDIUM: 10,
    WHISK_IMAGE_LARGE: 25,
    FLOW_PIPELINE_SIMPLE: 2,
    FLOW_PIPELINE_COMPLEX: 8,
    FLOW_DISTILLATION: 4,
} as const;

/** Supported AI service types */
export type AIService = "whisk" | "flow";

/** Credit usage log entry structure */
export interface CreditUsageEntry {
    service: AIService;
    timestamp: FirebaseFirestore.Timestamp;
    creditsUsed: number;
    featureId: string;
    userId?: string;
    metadata?: Record<string, unknown>;
}

/** Result of a credit check operation */
export interface CreditCheckResult {
    allowed: boolean;
    remainingCredits: number;
    monthlyUsed: number;
    percentageUsed: number;
}

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
export class AIManager {
    private readonly db: FirebaseFirestore.Firestore;
    private readonly usageCollection: string;

    /**
     * Creates a new AIManager instance.
     *
     * @param projectId - Firebase project ID (defaults to orbeit-613)
     */
    constructor(projectId: string = "orbeit-613") {
        this.db = getFirestore();
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
    async checkCredits(requestedCredits: number): Promise<CreditCheckResult> {
        try {
            const monthlyUsed = await this.getMonthlyUsage();
            const remainingCredits = MONTHLY_CREDIT_LIMIT - monthlyUsed;
            const allowed = requestedCredits <= remainingCredits;

            const result: CreditCheckResult = {
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
        } catch (error) {
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
    async logUsage(
        service: AIService,
        creditsUsed: number,
        featureId: string,
        userId?: string,
        metadata?: Record<string, unknown>
    ): Promise<CreditUsageEntry> {
        const entry: CreditUsageEntry = {
            service,
            timestamp: FieldValue.serverTimestamp() as FirebaseFirestore.Timestamp,
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
        } catch (error) {
            logger.error("Failed to log credit usage", { error, entry });
            throw new Error(`Failed to log credit usage: ${error}`);
        }
    }

    /**
     * Gets the total credit usage for the current month.
     *
     * @returns Promise resolving to total credits used this month
     */
    async getMonthlyUsage(): Promise<number> {
        try {
            const now = new Date();
            const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);

            const snapshot = await this.db
                .collection(this.usageCollection)
                .where("timestamp", ">=", monthStart)
                .get();

            let total = 0;
            snapshot.forEach((doc) => {
                const data = doc.data() as CreditUsageEntry;
                total += data.creditsUsed || 0;
            });

            return total;
        } catch (error) {
            logger.error("Failed to get monthly usage", { error });
            return 0;
        }
    }

    /**
     * Updates the monthly aggregate counter atomically.
     *
     * @param creditsToAdd - Credits to add to the monthly total
     */
    private async updateMonthlyAggregate(creditsToAdd: number): Promise<void> {
        const now = new Date();
        const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;
        const aggregateRef = this.db.doc(`metadata/credits/monthly/${monthKey}`);

        await aggregateRef.set(
            {
                totalUsed: FieldValue.increment(creditsToAdd),
                lastUpdated: FieldValue.serverTimestamp(),
                monthKey,
            },
            { merge: true }
        );
    }

    /**
     * Gets a summary of credit usage for analytics.
     *
     * @returns Promise resolving to usage summary object
     */
    async getUsageSummary(): Promise<{
        monthlyUsed: number;
        monthlyLimit: number;
        remaining: number;
        percentageUsed: number;
        estimatedDaysRemaining: number;
    }> {
        const monthlyUsed = await this.getMonthlyUsage();
        const now = new Date();
        const daysInMonth = new Date(
            now.getFullYear(),
            now.getMonth() + 1,
            0
        ).getDate();
        const dayOfMonth = now.getDate();
        const daysRemaining = daysInMonth - dayOfMonth;

        const dailyAverage = monthlyUsed / dayOfMonth;
        const remaining = MONTHLY_CREDIT_LIMIT - monthlyUsed;
        const estimatedDaysRemaining =
            dailyAverage > 0 ? Math.floor(remaining / dailyAverage) : daysRemaining;

        return {
            monthlyUsed,
            monthlyLimit: MONTHLY_CREDIT_LIMIT,
            remaining,
            percentageUsed: (monthlyUsed / MONTHLY_CREDIT_LIMIT) * 100,
            estimatedDaysRemaining: Math.min(estimatedDaysRemaining, daysRemaining),
        };
    }
}

/** Singleton instance for global access */
let _instance: AIManager | null = null;

/**
 * Gets the singleton AIManager instance.
 *
 * @returns The global AIManager instance
 */
export function getAIManager(): AIManager {
    if (!_instance) {
        _instance = new AIManager();
    }
    return _instance;
}
