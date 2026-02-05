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

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { AIManager, CREDIT_COSTS, getAIManager } from "./ai_manager";
import crypto from "crypto";

/**
 * Supported asset types for generation.
 * Each type has specific dimensions and style requirements.
 */
export type AssetType =
    | "badge"
    | "terrain_tile"
    | "avatar"
    | "icon"
    | "background"
    | "orb";

/**
 * Size configuration for generated assets.
 */
export type AssetSize = "small" | "medium" | "large";

/** Size dimensions mapping */
const SIZE_DIMENSIONS: Record<AssetSize, { width: number; height: number }> = {
    small: { width: 256, height: 256 },
    medium: { width: 512, height: 512 },
    large: { width: 1024, height: 1024 },
};

/**
 * Sovereign Sanctum aesthetic configuration.
 * Defines the visual language for all generated assets.
 */
const SANCTUM_AESTHETIC = {
    /** Core style descriptors */
    style: [
        "minimalist",
        "techno-organic",
        "sacred geometry",
        "clean vector lines",
        "subtle glow effects",
    ],
    /** Primary color palette */
    colors: {
        primaryGold: "#D4AF37",
        accentGold: "#FFD700",
        deepTeal: "#134E5E",
        darkSlate: "#1A1A2E",
        softWhite: "#F5F5F5",
        mysteryPurple: "#2D1B4E",
    },
    /** Background style modifiers */
    backgrounds: [
        "deep teal gradient",
        "dark slate with subtle texture",
        "cosmic dark blue",
    ],
    /** Accent descriptors */
    accents: [
        "geometric gold accents",
        "sacred geometry patterns",
        "soft golden glow",
        "minimalist linework",
    ],
} as const;

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
 * Cache entry structure in Firestore.
 */
interface CacheEntry {
    promptHash: string;
    assetUrl: string;
    assetId: string;
    assetType: AssetType;
    size: AssetSize;
    createdAt: FirebaseFirestore.Timestamp;
    accessCount: number;
    lastAccessedAt: FirebaseFirestore.Timestamp;
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
export class WhiskService {
    private readonly db: FirebaseFirestore.Firestore;
    private readonly aiManager: AIManager;
    private readonly cacheCollection = "whisk_cache";
    private readonly storageBucket: string;

    /**
     * Creates a new WhiskService instance.
     *
     * @param bucketName - Cloud Storage bucket for assets
     */
    constructor(bucketName: string = "orbeit-613.appspot.com") {
        this.db = getFirestore();
        this.aiManager = getAIManager();
        this.storageBucket = bucketName;
        logger.info("WhiskService initialized", { bucket: bucketName });
    }

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
    async generateAsset(
        request: AssetGenerationRequest
    ): Promise<AssetGenerationResponse> {
        const { assetType, context, size = "medium", userId } = request;

        // Build the Sanctum-styled prompt
        const prompt = this.buildPrompt(assetType, context, request.styleModifiers);
        const promptHash = this.hashPrompt(prompt, size);

        logger.info("Asset generation requested", {
            assetType,
            size,
            promptHash,
        });

        // Check cache first
        const cached = await this.checkCache(promptHash);
        if (cached) {
            logger.info("Cache hit for asset", { promptHash, assetId: cached.assetId });
            await this.updateCacheAccess(promptHash);
            return {
                fromCache: true,
                assetUrl: cached.assetUrl,
                assetId: cached.assetId,
                creditsUsed: 0,
                promptUsed: prompt,
                generatedAt: cached.createdAt.toDate().toISOString(),
            };
        }

        // Calculate credit cost based on size
        const creditCost = this.getCreditCost(size);

        // Check credit availability
        const creditCheck = await this.aiManager.checkCredits(creditCost);
        if (!creditCheck.allowed) {
            logger.error("Insufficient credits for asset generation", {
                required: creditCost,
                remaining: creditCheck.remainingCredits,
            });
            throw new Error(
                `Insufficient credits. Required: ${creditCost}, Available: ${creditCheck.remainingCredits}`
            );
        }

        // Generate the asset via Whisk API
        const assetId = this.generateAssetId(assetType);
        const assetUrl = await this.callWhiskAPI(prompt, size, assetId);

        // Cache the result
        await this.cacheAsset(promptHash, assetUrl, assetId, assetType, size);

        // Log credit usage
        await this.aiManager.logUsage("whisk", creditCost, `${assetType}_generation`, userId, {
            promptHash,
            size,
            assetId,
        });

        logger.info("Asset generated successfully", {
            assetId,
            creditCost,
            size,
        });

        return {
            fromCache: false,
            assetUrl,
            assetId,
            creditsUsed: creditCost,
            promptUsed: prompt,
            generatedAt: new Date().toISOString(),
        };
    }

    /**
     * Builds a Sovereign Sanctum-styled prompt for asset generation.
     *
     * @param assetType - Type of asset to generate
     * @param context - User-provided context
     * @param modifiers - Additional style modifiers
     * @returns Formatted prompt string
     */
    private buildPrompt(
        assetType: AssetType,
        context: string,
        modifiers?: string[]
    ): string {
        const typePrompts: Record<AssetType, string> = {
            badge: "circular achievement badge with sacred geometry border",
            terrain_tile: "isometric terrain tile with subtle texture",
            avatar: "minimalist avatar silhouette with aura glow",
            icon: "simple iconographic symbol with clean lines",
            background: "atmospheric background with depth layers",
            orb: "luminous orb with inner light and geometric patterns",
        };

        const aesthetic = SANCTUM_AESTHETIC;
        const basePrompt = typePrompts[assetType];

        const promptParts = [
            basePrompt,
            context,
            `Style: ${aesthetic.style.join(", ")}`,
            `Colors: gold accents (${aesthetic.colors.primaryGold}), deep teal background (${aesthetic.colors.deepTeal}), dark slate (${aesthetic.colors.darkSlate})`,
            aesthetic.accents.join(", "),
            "high quality, digital art, clean edges, no text",
        ];

        if (modifiers && modifiers.length > 0) {
            promptParts.push(modifiers.join(", "));
        }

        return promptParts.join(". ");
    }

    /**
     * Creates a deterministic hash of the prompt for caching.
     *
     * @param prompt - The full prompt text
     * @param size - Asset size
     * @returns SHA-256 hash string
     */
    private hashPrompt(prompt: string, size: AssetSize): string {
        const data = `${prompt}|${size}`;
        return crypto.createHash("sha256").update(data).digest("hex").substring(0, 32);
    }

    /**
     * Checks if a cached version of the asset exists.
     *
     * @param promptHash - Hash of the prompt to check
     * @returns Cache entry if found, null otherwise
     */
    private async checkCache(promptHash: string): Promise<CacheEntry | null> {
        try {
            const doc = await this.db.collection(this.cacheCollection).doc(promptHash).get();
            if (doc.exists) {
                return doc.data() as CacheEntry;
            }
            return null;
        } catch (error) {
            logger.warn("Cache check failed", { error, promptHash });
            return null;
        }
    }

    /**
     * Updates cache access statistics.
     *
     * @param promptHash - Hash of the accessed cache entry
     */
    private async updateCacheAccess(promptHash: string): Promise<void> {
        try {
            await this.db.collection(this.cacheCollection).doc(promptHash).update({
                accessCount: FieldValue.increment(1),
                lastAccessedAt: FieldValue.serverTimestamp(),
            });
        } catch (error) {
            logger.warn("Failed to update cache access", { error, promptHash });
        }
    }

    /**
     * Stores generated asset in cache.
     *
     * @param promptHash - Unique hash for the prompt
     * @param assetUrl - URL to the generated asset
     * @param assetId - Unique asset identifier
     * @param assetType - Type of asset
     * @param size - Asset size
     */
    private async cacheAsset(
        promptHash: string,
        assetUrl: string,
        assetId: string,
        assetType: AssetType,
        size: AssetSize
    ): Promise<void> {
        const entry: Omit<CacheEntry, "createdAt" | "lastAccessedAt"> & {
            createdAt: FirebaseFirestore.FieldValue;
            lastAccessedAt: FirebaseFirestore.FieldValue;
        } = {
            promptHash,
            assetUrl,
            assetId,
            assetType,
            size,
            createdAt: FieldValue.serverTimestamp(),
            accessCount: 1,
            lastAccessedAt: FieldValue.serverTimestamp(),
        };

        await this.db.collection(this.cacheCollection).doc(promptHash).set(entry);
        logger.info("Asset cached", { promptHash, assetId });
    }

    /**
     * Calculates credit cost based on asset size.
     *
     * @param size - Asset size
     * @returns Credit cost for the operation
     */
    private getCreditCost(size: AssetSize): number {
        switch (size) {
            case "small":
                return CREDIT_COSTS.WHISK_IMAGE_SMALL;
            case "medium":
                return CREDIT_COSTS.WHISK_IMAGE_MEDIUM;
            case "large":
                return CREDIT_COSTS.WHISK_IMAGE_LARGE;
            default:
                return CREDIT_COSTS.WHISK_IMAGE_MEDIUM;
        }
    }

    /**
     * Generates a unique asset ID.
     *
     * @param assetType - Type of asset
     * @returns Unique identifier string
     */
    private generateAssetId(assetType: AssetType): string {
        const timestamp = Date.now().toString(36);
        const random = crypto.randomBytes(4).toString("hex");
        return `${assetType}_${timestamp}_${random}`;
    }

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
    private async callWhiskAPI(
        prompt: string,
        size: AssetSize,
        assetId: string
    ): Promise<string> {
        const dimensions = SIZE_DIMENSIONS[size];

        logger.info("Calling Whisk API", {
            assetId,
            dimensions,
            promptLength: prompt.length,
        });

        // TODO: Implement actual Whisk API call
        // For now, return a placeholder path structure
        // The actual implementation will:
        // 1. Call the Whisk API with the prompt
        // 2. Receive the generated image
        // 3. Upload to Cloud Storage
        // 4. Return the public URL

        const storagePath = `generated_assets/${assetId}.png`;
        const placeholderUrl = `https://storage.googleapis.com/${this.storageBucket}/${storagePath}`;

        // Simulate API latency
        await new Promise((resolve) => setTimeout(resolve, 100));

        logger.info("Whisk API call completed (placeholder)", {
            assetId,
            storagePath,
        });

        return placeholderUrl;
    }
}

/** Singleton instance */
let _whiskInstance: WhiskService | null = null;

/**
 * Gets the singleton WhiskService instance.
 *
 * @returns The global WhiskService instance
 */
export function getWhiskService(): WhiskService {
    if (!_whiskInstance) {
        _whiskInstance = new WhiskService();
    }
    return _whiskInstance;
}
