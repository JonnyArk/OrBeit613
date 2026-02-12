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

import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions/v2";
import { onRequest, onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";

// AI Services
import {
    getAIManager,
    getWhiskService,
    getFlowService,
    type AssetGenerationRequest,
    type DistillationRequest,
} from "./ai";

// Initialize Firebase Admin
initializeApp();

// Define secrets (set via: firebase functions:secrets:set SECRET_NAME)
const googleAIUltraKey = defineSecret("GOOGLE_AI_ULTRA_KEY");

// Global options for cost control and security
setGlobalOptions({
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
export const healthCheck = onRequest(async (_request, response) => {
    logger.info("Health check requested", { structuredData: true });

    const aiManager = getAIManager();
    const usageSummary = await aiManager.getUsageSummary();

    response.json({
        status: "healthy",
        project: "orbeit-613",
        version: "1.0.0",
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || "development",
        credits: {
            remaining: usageSummary.remaining,
            percentageUsed: usageSummary.percentageUsed.toFixed(1) + "%",
        },
    });
});

/**
 * Credit usage summary endpoint for monitoring AI resource consumption.
 * Secure Callable Function requiring authentication.
 *
 * @param request - The callable request
 * @returns JSON response with credit usage statistics
 */
export const creditUsage = onCall(async (request) => {
    if (!request.auth) {
        throw new HttpsError(
            "unauthenticated",
            "User must be authenticated to check credit usage."
        );
    }

    try {
        const aiManager = getAIManager();
        const summary = await aiManager.getUsageSummary();

        logger.info("Credit usage requested", {
            uid: request.auth.uid,
            ...summary,
        });

        return {
            success: true,
            data: summary,
            timestamp: new Date().toISOString(),
        };
    } catch (error) {
        logger.error("Failed to get credit usage", { error });
        throw new HttpsError("internal", "Failed to retrieve credit usage");
    }
});

/**
 * Generate visual asset using Whisk service.
 * Implements the Sovereign Sanctum aesthetic with caching.
 * Secure Callable Function requiring authentication.
 *
 * @param request - Callable request with AssetGenerationRequest data
 * @returns Generated asset URL and metadata
 */
export const generateAsset = onCall(
    { secrets: [googleAIUltraKey] },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError(
                "unauthenticated",
                "User must be authenticated to generate assets."
            );
        }

        try {
            const body = request.data as AssetGenerationRequest;

            // Validate required fields
            if (!body.assetType || !body.context) {
                throw new HttpsError(
                    "invalid-argument",
                    "Missing required fields: assetType and context"
                );
            }

            // Force userId to be the authenticated user to prevent spoofing
            body.userId = request.auth.uid;

            logger.info("Asset generation request received", {
                uid: request.auth.uid,
                assetType: body.assetType,
                size: body.size || "medium",
            });

            const whiskService = getWhiskService();
            const result = await whiskService.generateAsset(body);

            return {
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            };
        } catch (error) {
            logger.error("Asset generation failed", { error });
            const errorMessage =
                error instanceof Error ? error.message : "Unknown error";
            throw new HttpsError("internal", errorMessage);
        }
    }
);

/**
 * Distill raw context into structured Life Event using Flow service.
 * Implements the Sovereign Pipeline for context processing.
 * Secure Callable Function requiring authentication.
 *
 * @param request - Callable request with DistillationRequest data
 * @returns Structured Life Event
 */
export const distillContext = onCall(
    { secrets: [googleAIUltraKey] },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError(
                "unauthenticated",
                "User must be authenticated to distill context."
            );
        }

        try {
            const body = request.data as DistillationRequest;

            // Validate required fields
            if (!body.rawData || !body.dataType) {
                throw new HttpsError(
                    "invalid-argument",
                    "Missing required fields: rawData and dataType"
                );
            }

            // Force userId to be the authenticated user to prevent spoofing
            body.userId = request.auth.uid;

            logger.info("Context distillation request received", {
                uid: request.auth.uid,
                dataType: body.dataType,
                complexity: body.complexity || "standard",
                inputLength: body.rawData.length,
            });

            const flowService = getFlowService();
            const result = await flowService.distillContext(body);

            return {
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            };
        } catch (error) {
            logger.error("Context distillation failed", { error });
            const errorMessage =
                error instanceof Error ? error.message : "Unknown error";
            throw new HttpsError("internal", errorMessage);
        }
    }
);
