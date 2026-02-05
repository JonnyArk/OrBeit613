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
/** Credit costs per operation type */
export declare const CREDIT_COSTS: {
    readonly WHISK_IMAGE_SMALL: 5;
    readonly WHISK_IMAGE_MEDIUM: 10;
    readonly WHISK_IMAGE_LARGE: 25;
    readonly FLOW_PIPELINE_SIMPLE: 2;
    readonly FLOW_PIPELINE_COMPLEX: 8;
    readonly FLOW_DISTILLATION: 4;
};
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
export declare class AIManager {
    private readonly db;
    private readonly usageCollection;
    /**
     * Creates a new AIManager instance.
     *
     * @param projectId - Firebase project ID (defaults to orbeit-613)
     */
    constructor(projectId?: string);
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
    checkCredits(requestedCredits: number): Promise<CreditCheckResult>;
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
    logUsage(service: AIService, creditsUsed: number, featureId: string, userId?: string, metadata?: Record<string, unknown>): Promise<CreditUsageEntry>;
    /**
     * Gets the total credit usage for the current month.
     *
     * @returns Promise resolving to total credits used this month
     */
    getMonthlyUsage(): Promise<number>;
    /**
     * Updates the monthly aggregate counter atomically.
     *
     * @param creditsToAdd - Credits to add to the monthly total
     */
    private updateMonthlyAggregate;
    /**
     * Gets a summary of credit usage for analytics.
     *
     * @returns Promise resolving to usage summary object
     */
    getUsageSummary(): Promise<{
        monthlyUsed: number;
        monthlyLimit: number;
        remaining: number;
        percentageUsed: number;
        estimatedDaysRemaining: number;
    }>;
}
/**
 * Gets the singleton AIManager instance.
 *
 * @returns The global AIManager instance
 */
export declare function getAIManager(): AIManager;
//# sourceMappingURL=ai_manager.d.ts.map