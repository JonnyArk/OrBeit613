/**
 * OrBeit Whisk Service - AI-Powered Asset Generation
 *
 * @packageDocumentation
 * @module ai/whisk_service
 *
 * Handles visual asset generation using Google Whisk API.
 * Implements the "Sovereign Sanctum" aesthetic with caching
 * to optimize credit usage.
 */
/**
 * Supported asset types for generation.
 * Each type has specific dimensions and style requirements.
 */
export type AssetType = "badge" | "terrain_tile" | "avatar" | "icon" | "background" | "orb";
/**
 * Size configuration for generated assets.
 */
export type AssetSize = "small" | "medium" | "large";
/**
 * Request payload for asset generation.
 */
export interface AssetGenerationRequest {
    /** Type of asset to generate */
    assetType: AssetType;
    /** Contextual description for the asset */
    context: string;
    /** Output size (affects credit cost) */
    size?: AssetSize;
    /** Optional user ID for caching scope */
    userId?: string;
    /** Additional style modifiers */
    styleModifiers?: string[];
}
/**
 * Response from asset generation.
 */
export interface AssetGenerationResponse {
    /** Whether asset was retrieved from cache */
    fromCache: boolean;
    /** Cloud Storage URL to the generated asset */
    assetUrl: string;
    /** Unique asset identifier */
    assetId: string;
    /** Credits consumed (0 if cached) */
    creditsUsed: number;
    /** Generated prompt used for creation */
    promptUsed: string;
    /** Generation timestamp */
    generatedAt: string;
}
/**
 * Whisk Service for generating visual assets with caching.
 *
 * @remarks
 * Implements the Sovereign Sanctum aesthetic and optimizes
 * credit usage through intelligent caching.
 *
 * @example
 * const whisk = new WhiskService();
 * const result = await whisk.generateAsset({
 *   assetType: 'badge',
 *   context: 'achievement for completing first task',
 *   size: 'medium'
 * });
 */
export declare class WhiskService {
    private readonly db;
    private readonly aiManager;
    private readonly cacheCollection;
    private readonly storageBucket;
    /**
     * Creates a new WhiskService instance.
     *
     * @param bucketName - Cloud Storage bucket for assets
     */
    constructor(bucketName?: string);
    /**
     * Generates or retrieves a cached visual asset.
     *
     * @param request - Asset generation request parameters
     * @returns Promise resolving to generation response with asset URL
     *
     * @throws Error if credit limit exceeded or generation fails
     *
     * @example
     * const badge = await whisk.generateAsset({
     *   assetType: 'badge',
     *   context: 'gold star achievement',
     *   size: 'medium'
     * });
     * console.log(badge.assetUrl);
     */
    generateAsset(request: AssetGenerationRequest): Promise<AssetGenerationResponse>;
    /**
     * Builds a Sovereign Sanctum-styled prompt for asset generation.
     *
     * @param assetType - Type of asset to generate
     * @param context - User-provided context
     * @param modifiers - Additional style modifiers
     * @returns Formatted prompt string
     */
    private buildPrompt;
    /**
     * Creates a deterministic hash of the prompt for caching.
     *
     * @param prompt - The full prompt text
     * @param size - Asset size
     * @returns SHA-256 hash string
     */
    private hashPrompt;
    /**
     * Checks if a cached version of the asset exists.
     *
     * @param promptHash - Hash of the prompt to check
     * @returns Cache entry if found, null otherwise
     */
    private checkCache;
    /**
     * Updates cache access statistics.
     *
     * @param promptHash - Hash of the accessed cache entry
     */
    private updateCacheAccess;
    /**
     * Stores generated asset in cache.
     *
     * @param promptHash - Unique hash for the prompt
     * @param assetUrl - URL to the generated asset
     * @param assetId - Unique asset identifier
     * @param assetType - Type of asset
     * @param size - Asset size
     */
    private cacheAsset;
    /**
     * Calculates credit cost based on asset size.
     *
     * @param size - Asset size
     * @returns Credit cost for the operation
     */
    private getCreditCost;
    /**
     * Generates a unique asset ID.
     *
     * @param assetType - Type of asset
     * @returns Unique identifier string
     */
    private generateAssetId;
    /**
     * Calls the Google Whisk API to generate an image.
     *
     * @param prompt - Generation prompt
     * @param size - Output size
     * @param assetId - Asset identifier for storage
     * @returns Cloud Storage URL to the generated image
     *
     * @remarks
     * This is a placeholder implementation. In production,
     * this will call the actual Whisk API endpoint.
     */
    private callWhiskAPI;
}
/**
 * Gets the singleton WhiskService instance.
 *
 * @returns The global WhiskService instance
 */
export declare function getWhiskService(): WhiskService;
//# sourceMappingURL=whisk_service.d.ts.map