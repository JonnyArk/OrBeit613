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
 * Secure callable function requiring authentication.
 *
 * @param request - The callable request
 * @returns Promise resolving to JSON response with credit usage statistics
 * @throws {HttpsError} If user is not authenticated or internal error occurs
 *
 * @example
 * // Client-side usage:
 * // const functions = getFunctions();
 * // const creditUsage = httpsCallable(functions, 'creditUsage');
 * // const result = await creditUsage();
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
 * Secure callable function requiring authentication.
 *
 * @param request - The callable request containing AssetGenerationRequest data
 * @returns Promise resolving to object with generated asset URL
 * @throws {HttpsError} If user is not authenticated or input is invalid
 *
 * @example
 * // Client-side usage:
 * // const generateAsset = httpsCallable(functions, 'generateAsset');
 * // const result = await generateAsset({ assetType: 'badge', context: '...' });
 */
export declare const generateAsset: import("firebase-functions/v2/https").CallableFunction<any, Promise<{
    success: boolean;
    data: import("./ai").AssetGenerationResponse;
    timestamp: string;
}>, unknown>;
/**
 * Distill raw context into structured Life Event using Flow service.
 * Implements the Sovereign Pipeline for context processing.
 * Secure callable function requiring authentication.
 *
 * @param request - The callable request containing DistillationRequest data
 * @returns Promise resolving to object with structured Life Event
 * @throws {HttpsError} If user is not authenticated or input is invalid
 *
 * @example
 * // Client-side usage:
 * // const distillContext = httpsCallable(functions, 'distillContext');
 * // const result = await distillContext({ rawData: '...', dataType: 'note_text' });
 */
export declare const distillContext: import("firebase-functions/v2/https").CallableFunction<any, Promise<{
    success: boolean;
    data: import("./ai").DistillationResponse;
    timestamp: string;
}>, unknown>;
//# sourceMappingURL=index.d.ts.map