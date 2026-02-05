"use strict";
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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WhiskService = void 0;
exports.getWhiskService = getWhiskService;
const firestore_1 = require("firebase-admin/firestore");
const logger = __importStar(require("firebase-functions/logger"));
const ai_manager_1 = require("./ai_manager");
const crypto_1 = __importDefault(require("crypto"));
/** Size dimensions mapping */
const SIZE_DIMENSIONS = {
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
};
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
class WhiskService {
    db;
    aiManager;
    cacheCollection = "whisk_cache";
    storageBucket;
    /**
     * Creates a new WhiskService instance.
     *
     * @param bucketName - Cloud Storage bucket for assets
     */
    constructor(bucketName = "orbeit-613.appspot.com") {
        this.db = (0, firestore_1.getFirestore)();
        this.aiManager = (0, ai_manager_1.getAIManager)();
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
    async generateAsset(request) {
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
            throw new Error(`Insufficient credits. Required: ${creditCost}, Available: ${creditCheck.remainingCredits}`);
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
    buildPrompt(assetType, context, modifiers) {
        const typePrompts = {
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
    hashPrompt(prompt, size) {
        const data = `${prompt}|${size}`;
        return crypto_1.default.createHash("sha256").update(data).digest("hex").substring(0, 32);
    }
    /**
     * Checks if a cached version of the asset exists.
     *
     * @param promptHash - Hash of the prompt to check
     * @returns Cache entry if found, null otherwise
     */
    async checkCache(promptHash) {
        try {
            const doc = await this.db.collection(this.cacheCollection).doc(promptHash).get();
            if (doc.exists) {
                return doc.data();
            }
            return null;
        }
        catch (error) {
            logger.warn("Cache check failed", { error, promptHash });
            return null;
        }
    }
    /**
     * Updates cache access statistics.
     *
     * @param promptHash - Hash of the accessed cache entry
     */
    async updateCacheAccess(promptHash) {
        try {
            await this.db.collection(this.cacheCollection).doc(promptHash).update({
                accessCount: firestore_1.FieldValue.increment(1),
                lastAccessedAt: firestore_1.FieldValue.serverTimestamp(),
            });
        }
        catch (error) {
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
    async cacheAsset(promptHash, assetUrl, assetId, assetType, size) {
        const entry = {
            promptHash,
            assetUrl,
            assetId,
            assetType,
            size,
            createdAt: firestore_1.FieldValue.serverTimestamp(),
            accessCount: 1,
            lastAccessedAt: firestore_1.FieldValue.serverTimestamp(),
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
    getCreditCost(size) {
        switch (size) {
            case "small":
                return ai_manager_1.CREDIT_COSTS.WHISK_IMAGE_SMALL;
            case "medium":
                return ai_manager_1.CREDIT_COSTS.WHISK_IMAGE_MEDIUM;
            case "large":
                return ai_manager_1.CREDIT_COSTS.WHISK_IMAGE_LARGE;
            default:
                return ai_manager_1.CREDIT_COSTS.WHISK_IMAGE_MEDIUM;
        }
    }
    /**
     * Generates a unique asset ID.
     *
     * @param assetType - Type of asset
     * @returns Unique identifier string
     */
    generateAssetId(assetType) {
        const timestamp = Date.now().toString(36);
        const random = crypto_1.default.randomBytes(4).toString("hex");
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
    async callWhiskAPI(prompt, size, assetId) {
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
exports.WhiskService = WhiskService;
/** Singleton instance */
let _whiskInstance = null;
/**
 * Gets the singleton WhiskService instance.
 *
 * @returns The global WhiskService instance
 */
function getWhiskService() {
    if (!_whiskInstance) {
        _whiskInstance = new WhiskService();
    }
    return _whiskInstance;
}
//# sourceMappingURL=whisk_service.js.map