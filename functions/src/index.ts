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
import { onRequest } from "firebase-functions/v2/https";
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

import { requireAuth, type TypedRequest, type TypedResponse } from "./auth";

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
 */
export const healthCheck = onRequest(async (_request, response) => {
    logger.info("Health check requested", { structuredData: true });

    const aiManager = getAIManager();
    const usageSummary = await aiManager.getUsageSummary();

    const res = response as unknown as TypedResponse;
    res.json({
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
 */
export const creditUsage = onRequest(async (request, response) => {
    const res = response as unknown as TypedResponse;
    try {
        const req = request as unknown as TypedRequest;
        await requireAuth(req);

        const aiManager = getAIManager();
        const summary = await aiManager.getUsageSummary();

        logger.info("Credit usage requested", summary);

        res.json({
            success: true,
            data: summary,
            timestamp: new Date().toISOString(),
        });
    } catch (error) {
        logger.error("Failed to get credit usage", { error });
        if (error instanceof Error && error.message === "Unauthorized") {
            res.status(401).json({ success: false, error: "Unauthorized" });
            return;
        }
        res.status(500).json({
            success: false,
            error: "Failed to retrieve credit usage",
        });
    }
});

/**
 * Generate visual asset using Whisk service.
 */
export const generateAsset = onRequest(
    { secrets: [googleAIUltraKey] },
    async (request, response) => {
        const res = response as unknown as TypedResponse;
        // Only allow POST
        if (request.method !== "POST") {
            res.status(405).json({ error: "Method not allowed" });
            return;
        }

        try {
            const req = request as unknown as TypedRequest;
            const uid = await requireAuth(req);

            const body = request.body as AssetGenerationRequest;
            body.userId = uid;

            // Validate required fields
            if (!body.assetType || !body.context) {
                res.status(400).json({
                    error: "Missing required fields: assetType and context",
                });
                return;
            }

            logger.info("Asset generation request received", {
                assetType: body.assetType,
                size: body.size || "medium",
            });

            const whiskService = getWhiskService();
            const result = await whiskService.generateAsset(body);

            res.json({
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            });
        } catch (error) {
            logger.error("Asset generation failed", { error });
            if (error instanceof Error && error.message === "Unauthorized") {
                res.status(401).json({ success: false, error: "Unauthorized" });
                return;
            }
            res.status(500).json({
                success: false,
                error: "Internal server error",
            });
        }
    }
);

/**
 * Distill raw context into structured Life Event using Flow service.
 */
export const distillContext = onRequest(
    { secrets: [googleAIUltraKey] },
    async (request, response) => {
        const res = response as unknown as TypedResponse;
        // Only allow POST
        if (request.method !== "POST") {
            res.status(405).json({ error: "Method not allowed" });
            return;
        }

        try {
            const req = request as unknown as TypedRequest;
            const uid = await requireAuth(req);

            const body = request.body as DistillationRequest;
            body.userId = uid;

            // Validate required fields
            if (!body.rawData || !body.dataType) {
                res.status(400).json({
                    error: "Missing required fields: rawData and dataType",
                });
                return;
            }

            logger.info("Context distillation request received", {
                dataType: body.dataType,
                complexity: body.complexity || "standard",
                inputLength: body.rawData.length,
            });

            const flowService = getFlowService();
            const result = await flowService.distillContext(body);

            res.json({
                success: true,
                data: result,
                timestamp: new Date().toISOString(),
            });
        } catch (error) {
            logger.error("Context distillation failed", { error });
            if (error instanceof Error && error.message === "Unauthorized") {
                res.status(401).json({ success: false, error: "Unauthorized" });
                return;
            }
            res.status(500).json({
                success: false,
                error: "Internal server error",
            });
        }
    }
);
