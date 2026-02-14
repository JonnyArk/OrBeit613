"use strict";
/**
 * OrBeit Cloud Functions Entry Point
 *
 * @packageDocumentation
 * @module functions
 *
 * This module exports all Firebase Cloud Functions for the OrBeit platform.
 * All functions follow TypeScript strict mode and security best practices
 * as defined in .agent/rules/standards.md
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
exports.distillContext = exports.generateAsset = exports.creditUsage = exports.healthCheck = void 0;
const app_1 = require("firebase-admin/app");
const v2_1 = require("firebase-functions/v2");
const https_1 = require("firebase-functions/v2/https");
const params_1 = require("firebase-functions/params");
const logger = __importStar(require("firebase-functions/logger"));
// AI Services
const ai_1 = require("./ai");
// Initialize Firebase Admin
(0, app_1.initializeApp)();
// Define secrets (set via: firebase functions:secrets:set SECRET_NAME)
const googleAIUltraKey = (0, params_1.defineSecret)("GOOGLE_AI_ULTRA_KEY");
// Global options for cost control and security
(0, v2_1.setGlobalOptions)({
    maxInstances: 10,
    region: "us-central1",
});
/**
 * Health check endpoint for monitoring service availability.
 *
 * @param _request - The incoming HTTP request
 * @param response - The HTTP response object
 * @returns JSON response with service status and timestamp
 *
 * @example
 * // GET https://us-central1-orbeit-613.cloudfunctions.net/healthCheck
 * // Response: { "status": "healthy", "project": "orbeit-613", "timestamp": "..." }
 */
exports.healthCheck = (0, https_1.onRequest)(async (_request, response) => {
    logger.info("Health check requested", { structuredData: true });
    // Note: Credit usage removed for security (public endpoint)
    response.json({
        status: "healthy",
        project: "orbeit-613",
        version: "1.0.0",
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || "development",
    });
});
/**
 * Credit usage summary endpoint for monitoring AI resource consumption.
 * Securely callable by authenticated users.
 *
 * @returns JSON response with credit usage statistics
 */
exports.creditUsage = (0, https_1.onCall)(async (request) => {
    // Security: Ensure user is authenticated
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "User must be authenticated to check credit usage.");
    }
    try {
        const aiManager = (0, ai_1.getAIManager)();
        const summary = await aiManager.getUsageSummary();
        logger.info("Credit usage requested", {
            uid: request.auth.uid,
            summary,
        });
        return {
            success: true,
            data: summary,
            timestamp: new Date().toISOString(),
        };
    }
    catch (error) {
        logger.error("Failed to get credit usage", { error });
        throw new https_1.HttpsError("internal", "Failed to retrieve credit usage");
    }
});
/**
 * Generate visual asset using Whisk service.
 * Implements the Sovereign Sanctum aesthetic with caching.
 * Securely callable by authenticated users.
 *
 * @param request - Request with AssetGenerationRequest data
 * @returns Object with generated asset URL
 */
exports.generateAsset = (0, https_1.onCall)({ secrets: [googleAIUltraKey] }, async (request) => {
    // Security: Ensure user is authenticated
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "User must be authenticated to generate assets.");
    }
    try {
        const body = request.data;
        // Validate required fields
        if (!body.assetType || !body.context) {
            throw new https_1.HttpsError("invalid-argument", "Missing required fields: assetType and context");
        }
        logger.info("Asset generation request received", {
            uid: request.auth.uid,
            assetType: body.assetType,
            size: body.size || "medium",
        });
        const whiskService = (0, ai_1.getWhiskService)();
        const result = await whiskService.generateAsset(body);
        return {
            success: true,
            data: result,
            timestamp: new Date().toISOString(),
        };
    }
    catch (error) {
        logger.error("Asset generation failed", { error });
        if (error instanceof https_1.HttpsError) {
            throw error;
        }
        const errorMessage = error instanceof Error ? error.message : "Unknown error";
        throw new https_1.HttpsError("internal", errorMessage);
    }
});
/**
 * Distill raw context into structured Life Event using Flow service.
 * Implements the Sovereign Pipeline for context processing.
 * Securely callable by authenticated users.
 *
 * @param request - Request with DistillationRequest data
 * @returns Object with structured Life Event
 */
exports.distillContext = (0, https_1.onCall)({ secrets: [googleAIUltraKey] }, async (request) => {
    // Security: Ensure user is authenticated
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "User must be authenticated to distill context.");
    }
    try {
        const body = request.data;
        // Validate required fields
        if (!body.rawData || !body.dataType) {
            throw new https_1.HttpsError("invalid-argument", "Missing required fields: rawData and dataType");
        }
        logger.info("Context distillation request received", {
            uid: request.auth.uid,
            dataType: body.dataType,
            complexity: body.complexity || "standard",
            inputLength: body.rawData.length,
        });
        const flowService = (0, ai_1.getFlowService)();
        const result = await flowService.distillContext(body);
        return {
            success: true,
            data: result,
            timestamp: new Date().toISOString(),
        };
    }
    catch (error) {
        logger.error("Context distillation failed", { error });
        if (error instanceof https_1.HttpsError) {
            throw error;
        }
        const errorMessage = error instanceof Error ? error.message : "Unknown error";
        throw new https_1.HttpsError("internal", errorMessage);
    }
});
//# sourceMappingURL=index.js.map