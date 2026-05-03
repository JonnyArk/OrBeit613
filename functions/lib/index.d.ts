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
 */
export declare const healthCheck: import("firebase-functions/https").HttpsFunction;
/**
 * Credit usage summary endpoint for monitoring AI resource consumption.
 */
export declare const creditUsage: import("firebase-functions/https").HttpsFunction;
/**
 * Generate visual asset using Whisk service.
 */
export declare const generateAsset: import("firebase-functions/https").HttpsFunction;
/**
 * Distill raw context into structured Life Event using Flow service.
 */
export declare const distillContext: import("firebase-functions/https").HttpsFunction;
//# sourceMappingURL=index.d.ts.map