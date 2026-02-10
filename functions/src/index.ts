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
import { getAuth } from "firebase-admin/auth";
import { setGlobalOptions } from "firebase-functions/v2";
import { onRequest, Request } from "firebase-functions/v2/https";
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
 * Helper to authenticate request and return user ID.
 * Throws error if unauthorized.
 *
 * @param request - The incoming HTTP request
 * @returns Promise resolving to the authenticated user ID
 */
const authenticateRequest = async (request: Request): Promise<string> => {
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        throw new Error("Unauthorized: Missing or invalid Authorization header");
    }
    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await getAuth().verifyIdToken(idToken);
        return decodedToken.uid;
    } catch (error) {
        logger.warn("Authentication failed", { error });
        throw new Error("Unauthorized: Invalid token");
    }
};

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
 *
 * @param _request - The incoming HTTP request
 * @param response - The HTTP response object
 * @returns JSON response with credit usage statistics
 *
 * @example
 * // GET https://us-central1-orbeit-613.cloudfunctions.net/creditUsage
 */
export const creditUsage = onRequest(async (_request, response) => {
    try {
        const aiManager = getAIManager();
        const summary = await aiManager.getUsageSummary();

        logger.info("Credit usage requested", summary);

        response.json({
            success: true,
            data: summary,
            timestamp: new Date().toISOString(),
        });
    } catch (error) {
        logger.error("Failed to get credit usage", { error });
        response.status(500).json({
            success: false,
            error: "Failed to retrieve credit usage",
        });
    }
});

/**
 * Generate visual asset using Whisk service.
 * Implements the Sovereign Sanctum aesthetic with caching.
 *
 * @param request - HTTP request with AssetGenerationRequest body
 * @param response - HTTP response with generated asset URL
 *
 * @example
 * // POST https://us-central1-orbeit-613.cloudfunctions.net/generateAsset
 * // Body: { "assetType": "badge", "context": "first task completed", "size": "medium" }
 */
export const generateAsset = onRequest(
    { secrets: [googleAIUltraKey] },
    async (request, response) => {
        // Only allow POST
        if (request.method !== "POST") {
            response.status(405).json({ error: "Method not allowed" });
            return;
        }

        try {
            // Authenticate user
            let userId: string;
            try {
                userId = await authenticateRequest(request);
            } catch {
                response.status(401).json({ error: "Unauthorized" });
                return;
            }

            const body = request.body as AssetGenerationRequest;

            // Validate required fields
            if (!body.assetType || !body.context) {
                response.status(400).json({
                    error: "Missing required fields: assetType and context",
                });
                return;
            }

            // Enforce authenticated user ID
            body.userId = userId;

            logger.info("Asset generation request received", {
                assetType: body.assetType,
                size: body.size || "medium",
                userId, // Log the authenticated user ID
            });

            const whiskService = getWhiskService();
            const result = await whiskService.generateAsset(body);

            response.json({
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            });
        } catch (error) {
            logger.error("Asset generation failed", { error });
            const errorMessage =
                error instanceof Error ? error.message : "Unknown error";
            response.status(500).json({
                success: false,
                error: errorMessage,
            });
        }
    }
);

/**
 * Distill raw context into structured Life Event using Flow service.
 * Implements the Sovereign Pipeline for context processing.
 *
 * @param request - HTTP request with DistillationRequest body
 * @param response - HTTP response with structured Life Event
 *
 * @example
 * // POST https://us-central1-orbeit-613.cloudfunctions.net/distillContext
 * // Body: { "rawData": "Had coffee with Sarah...", "dataType": "note_text" }
 */
export const distillContext = onRequest(
    { secrets: [googleAIUltraKey] },
    async (request, response) => {
        // Only allow POST
        if (request.method !== "POST") {
            response.status(405).json({ error: "Method not allowed" });
            return;
        }

        try {
            // Authenticate user
            let userId: string;
            try {
                userId = await authenticateRequest(request);
            } catch {
                response.status(401).json({ error: "Unauthorized" });
                return;
            }

            const body = request.body as DistillationRequest;

            // Validate required fields
            if (!body.rawData || !body.dataType) {
                response.status(400).json({
                    error: "Missing required fields: rawData and dataType",
                });
                return;
            }

            // Enforce authenticated user ID
            body.userId = userId;

            logger.info("Context distillation request received", {
                dataType: body.dataType,
                complexity: body.complexity || "standard",
                inputLength: body.rawData.length,
                userId, // Log the authenticated user ID
            });

            const flowService = getFlowService();
            const result = await flowService.distillContext(body);

            response.json({
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            });
        } catch (error) {
            logger.error("Context distillation failed", { error });
            const errorMessage =
                error instanceof Error ? error.message : "Unknown error";
            response.status(500).json({
                success: false,
                error: errorMessage,
            });
        }
    }
);
