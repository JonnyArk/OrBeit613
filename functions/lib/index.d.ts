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
export declare const healthCheck: import("firebase-functions/v2/https").HttpsFunction;
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
export declare const creditUsage: import("firebase-functions/v2/https").CallableFunction<any, Promise<{
    success: boolean;
    data: {
        monthlyUsed: number;
        monthlyLimit: number;
        remaining: number;
        percentageUsed: number;
        estimatedDaysRemaining: number;
    };
    timestamp: string;
}>, unknown>;
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
export declare const generateAsset: import("firebase-functions/v2/https").CallableFunction<any, Promise<{
    success: boolean;
    data: import("./ai").AssetGenerationResponse;
    timestamp: string;
}>, unknown>;
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
export declare const distillContext: import("firebase-functions/v2/https").CallableFunction<any, Promise<{
    success: boolean;
    data: import("./ai").DistillationResponse;
    timestamp: string;
}>, unknown>;
//# sourceMappingURL=index.d.ts.map