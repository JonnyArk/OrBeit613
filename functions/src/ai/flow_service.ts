/**
 * OrBeit Flow Service - AI Workflow Pipelines
 *
 * @packageDocumentation
 * @module ai/flow_service
 *
 * Handles automated workflow orchestration using Google Flow API.
 * Implements the "Sovereign Pipeline" for context distillation,
 * transforming raw user data into structured Life Events.
 */

import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { AIManager, CREDIT_COSTS, getAIManager } from "./ai_manager";
import crypto from "crypto";

/**
 * Supported input data types for processing.
 */
export type InputDataType =
    | "sensor_data"
    | "note_text"
    | "voice_transcript"
    | "location_context"
    | "calendar_event"
    | "health_metric";

/**
 * Pipeline complexity levels affecting credit cost.
 */
export type PipelineComplexity = "simple" | "standard" | "complex";

/**
 * Life Event categories for Drift database storage.
 */
export type LifeEventCategory =
    | "task"
    | "memory"
    | "health"
    | "location"
    | "relationship"
    | "achievement"
    | "reflection"
    | "routine";

/**
 * Structured Life Event output format.
 * This schema maps directly to the Drift local database.
 */
export interface LifeEvent {
    /** Unique event identifier */
    id: string;
    /** Event category for organization */
    category: LifeEventCategory;
    /** Human-readable title */
    title: string;
    /** Detailed description */
    description: string;
    /** ISO 8601 timestamp when event occurred */
    occurredAt: string;
    /** Processing timestamp */
    processedAt: string;
    /** Spatial context (room/location in user's world) */
    spatialContext?: {
        roomId?: string;
        coordinates?: { x: number; y: number };
        locationName?: string;
    };
    /** Extracted entities (people, places, things) */
    entities: Array<{
        type: "person" | "place" | "thing" | "concept";
        name: string;
        relevance: number;
    }>;
    /** Emotional tone analysis */
    sentiment?: {
        score: number; // -1 to 1
        magnitude: number; // 0 to 1
        label: "positive" | "negative" | "neutral" | "mixed";
    };
    /** Extracted action items or tasks */
    actionItems?: Array<{
        text: string;
        priority: "low" | "medium" | "high";
        dueDate?: string;
    }>;
    /** Tags for filtering and search */
    tags: string[];
    /** Original source data hash for deduplication */
    sourceHash: string;
    /** Confidence score of the distillation */
    confidence: number;
    /** Raw input metadata (type, length, etc.) */
    inputMetadata: {
        dataType: InputDataType;
        characterCount: number;
        processingTimeMs: number;
    };
}

/**
 * Request payload for context distillation.
 */
export interface DistillationRequest {
    /** Raw input data to process */
    rawData: string;
    /** Type of input data */
    dataType: InputDataType;
    /** Optional user ID for personalization */
    userId?: string;
    /** Optional spatial context hint */
    spatialHint?: string;
    /** Optional timestamp override */
    occurredAt?: string;
    /** Pipeline complexity level */
    complexity?: PipelineComplexity;
}

/**
 * Response from context distillation.
 */
export interface DistillationResponse {
    /** Whether result was retrieved from cache */
    fromCache: boolean;
    /** Distilled Life Event */
    event: LifeEvent;
    /** Credits consumed */
    creditsUsed: number;
    /** Pipeline execution time in milliseconds */
    processingTimeMs: number;
}

/**
 * Flow Service for context distillation and workflow pipelines.
 *
 * @remarks
 * Implements the Sovereign Pipeline that transforms unstructured
 * user data into structured Life Events for the Drift database.
 *
 * @example
 * const flow = new FlowService();
 * const result = await flow.distillContext({
 *   rawData: "Had coffee with Sarah at the usual place...",
 *   dataType: 'note_text',
 *   userId: 'user123'
 * });
 * console.log(result.event.category); // 'relationship'
 */
export class FlowService {
    private readonly db: FirebaseFirestore.Firestore;
    private readonly aiManager: AIManager;
    private readonly cacheCollection = "flow_cache";
    private readonly eventsCollection = "life_events";

    /**
     * Creates a new FlowService instance.
     */
    constructor() {
        this.db = getFirestore();
        this.aiManager = getAIManager();
        logger.info("FlowService initialized");
    }

    /**
     * Distills raw unstructured data into a structured Life Event.
     *
     * @param request - Distillation request parameters
     * @returns Promise resolving to distillation response with Life Event
     *
     * @throws Error if credit limit exceeded or processing fails
     *
     * @example
     * const result = await flow.distillContext({
     *   rawData: "Meeting with team to discuss Q1 roadmap at 2pm",
     *   dataType: 'calendar_event'
     * });
     */
    async distillContext(
        request: DistillationRequest
    ): Promise<DistillationResponse> {
        const startTime = Date.now();
        const {
            rawData,
            dataType,
            userId,
            spatialHint,
            occurredAt,
            complexity = "standard",
        } = request;

        // Hash input for caching and deduplication
        const sourceHash = this.hashInput(rawData, dataType);

        logger.info("Context distillation requested", {
            dataType,
            complexity,
            inputLength: rawData.length,
            sourceHash,
        });

        // Check cache first
        const cached = await this.checkCache(sourceHash);
        if (cached) {
            logger.info("Cache hit for distillation", { sourceHash });
            return {
                fromCache: true,
                event: cached,
                creditsUsed: 0,
                processingTimeMs: Date.now() - startTime,
            };
        }

        // Calculate credit cost
        const creditCost = this.getCreditCost(complexity);

        // Check credit availability
        const creditCheck = await this.aiManager.checkCredits(creditCost);
        if (!creditCheck.allowed) {
            logger.error("Insufficient credits for distillation", {
                required: creditCost,
                remaining: creditCheck.remainingCredits,
            });
            throw new Error(
                `Insufficient credits. Required: ${creditCost}, Available: ${creditCheck.remainingCredits}`
            );
        }

        // Process through Sovereign Pipeline
        const event = await this.runSovereignPipeline(
            rawData,
            dataType,
            sourceHash,
            spatialHint,
            occurredAt
        );

        const processingTimeMs = Date.now() - startTime;
        event.inputMetadata = {
            dataType,
            characterCount: rawData.length,
            processingTimeMs,
        };

        // Parallelize independent post-processing tasks
        const promises = [];

        // Cache the result
        promises.push(this.cacheEvent(sourceHash, event));

        // Store event in Firestore for sync
        if (userId) {
            promises.push(this.storeEvent(userId, event));
        }

        // Log credit usage
        promises.push(this.aiManager.logUsage(
            "flow",
            creditCost,
            `distillation_${complexity}`,
            userId,
            {
                dataType,
                category: event.category,
                sourceHash,
                confidence: event.confidence,
            }
        ));

        await Promise.all(promises);

        logger.info("Context distillation complete", {
            eventId: event.id,
            category: event.category,
            confidence: event.confidence,
            processingTimeMs,
            creditCost,
        });

        return {
            fromCache: false,
            event,
            creditsUsed: creditCost,
            processingTimeMs,
        };
    }

    /**
     * Runs the Sovereign Pipeline to transform raw data.
     *
     * @param rawData - Raw input text
     * @param dataType - Type of input data
     * @param sourceHash - Hash for identification
     * @param spatialHint - Optional spatial context
     * @param occurredAt - Optional timestamp override
     * @returns Processed Life Event
     */
    private async runSovereignPipeline(
        rawData: string,
        dataType: InputDataType,
        sourceHash: string,
        spatialHint?: string,
        occurredAt?: string
    ): Promise<LifeEvent> {
        logger.info("Running Sovereign Pipeline", { dataType, sourceHash });

        // TODO: Replace with actual Flow API call
        // The pipeline will:
        // 1. Analyze input for category classification
        // 2. Extract named entities
        // 3. Perform sentiment analysis
        // 4. Extract action items
        // 5. Generate structured output

        const eventId = this.generateEventId();
        const category = this.inferCategory(rawData, dataType);
        const entities = this.extractEntities(rawData);
        const sentiment = this.analyzeSentiment(rawData);
        const actionItems = this.extractActionItems(rawData);
        const tags = this.generateTags(rawData, category, entities);

        const event: LifeEvent = {
            id: eventId,
            category,
            title: this.generateTitle(rawData, category),
            description: this.generateDescription(rawData),
            occurredAt: occurredAt || new Date().toISOString(),
            processedAt: new Date().toISOString(),
            spatialContext: spatialHint ? { locationName: spatialHint } : undefined,
            entities,
            sentiment,
            actionItems: actionItems.length > 0 ? actionItems : undefined,
            tags,
            sourceHash,
            confidence: 0.85, // Placeholder - actual API will provide this
            inputMetadata: {
                dataType,
                characterCount: rawData.length,
                processingTimeMs: 0, // Will be set after processing
            },
        };

        // Simulate API processing time
        await new Promise((resolve) => setTimeout(resolve, 50));

        return event;
    }

    /**
     * Infers the category of the Life Event from content.
     *
     * @param rawData - Raw input text
     * @param dataType - Input data type
     * @returns Inferred category
     */
    private inferCategory(
        rawData: string,
        dataType: InputDataType
    ): LifeEventCategory {
        const text = rawData.toLowerCase();

        // Heuristic category inference (placeholder for ML model)
        if (dataType === "health_metric") return "health";
        if (dataType === "location_context") return "location";
        if (dataType === "calendar_event") return "task";

        if (text.includes("meeting") || text.includes("task") || text.includes("todo")) {
            return "task";
        }
        if (text.includes("remember") || text.includes("memory") || text.includes("recalled")) {
            return "memory";
        }
        if (text.includes("health") || text.includes("exercise") || text.includes("sleep")) {
            return "health";
        }
        if (text.includes("achieved") || text.includes("completed") || text.includes("finished")) {
            return "achievement";
        }
        if (text.includes("with") && (text.includes("friend") || text.includes("family"))) {
            return "relationship";
        }
        if (text.includes("morning") || text.includes("routine") || text.includes("daily")) {
            return "routine";
        }
        if (text.includes("thought") || text.includes("reflect") || text.includes("journal")) {
            return "reflection";
        }

        return "memory"; // Default fallback
    }

    /**
     * Extracts named entities from text.
     *
     * @param rawData - Raw input text
     * @returns Array of extracted entities
     */
    private extractEntities(
        rawData: string
    ): LifeEvent["entities"] {
        // Placeholder entity extraction
        // Actual implementation will use NLP model
        const entities: LifeEvent["entities"] = [];

        // Simple name detection (capitalized words)
        const namePattern = /\b([A-Z][a-z]+)\b/g;
        const matches = rawData.match(namePattern) || [];

        const commonWords = new Set([
            "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
            "Saturday", "Sunday", "January", "February", "March",
            "April", "May", "June", "July", "August", "September",
            "October", "November", "December", "Today", "Tomorrow",
        ]);

        const uniqueNames = [...new Set(matches)].filter(
            (name) => !commonWords.has(name)
        );

        uniqueNames.slice(0, 5).forEach((name, index) => {
            entities.push({
                type: "person",
                name,
                relevance: 1 - index * 0.15,
            });
        });

        return entities;
    }

    /**
     * Analyzes sentiment of the input text.
     *
     * @param rawData - Raw input text
     * @returns Sentiment analysis result
     */
    private analyzeSentiment(rawData: string): LifeEvent["sentiment"] {
        // Placeholder sentiment analysis
        const text = rawData.toLowerCase();

        const positiveWords = ["happy", "great", "wonderful", "amazing", "good", "love", "excited"];
        const negativeWords = ["sad", "bad", "terrible", "awful", "hate", "angry", "frustrated"];

        let positiveCount = 0;
        let negativeCount = 0;

        positiveWords.forEach((word) => {
            if (text.includes(word)) positiveCount++;
        });

        negativeWords.forEach((word) => {
            if (text.includes(word)) negativeCount++;
        });

        const total = positiveCount + negativeCount;
        if (total === 0) {
            return { score: 0, magnitude: 0.1, label: "neutral" };
        }

        const score = (positiveCount - negativeCount) / total;
        const magnitude = Math.min(total / 5, 1);

        let label: "positive" | "negative" | "neutral" | "mixed";
        if (positiveCount > 0 && negativeCount > 0) {
            label = "mixed";
        } else if (score > 0.2) {
            label = "positive";
        } else if (score < -0.2) {
            label = "negative";
        } else {
            label = "neutral";
        }

        return { score, magnitude, label };
    }

    /**
     * Extracts action items from text.
     *
     * @param rawData - Raw input text
     * @returns Array of action items
     */
    private extractActionItems(
        rawData: string
    ): NonNullable<LifeEvent["actionItems"]> {
        const items: NonNullable<LifeEvent["actionItems"]> = [];

        // Pattern matching for action items
        const patterns = [
            /need to\s+(.+?)(?:\.|$)/gi,
            /should\s+(.+?)(?:\.|$)/gi,
            /todo:\s*(.+?)(?:\.|$)/gi,
            /reminder:\s*(.+?)(?:\.|$)/gi,
        ];

        patterns.forEach((pattern) => {
            const matches = rawData.matchAll(pattern);
            for (const match of matches) {
                if (match[1] && match[1].length > 5) {
                    items.push({
                        text: match[1].trim(),
                        priority: "medium",
                    });
                }
            }
        });

        return items.slice(0, 5); // Max 5 action items
    }

    /**
     * Generates a concise title for the event.
     *
     * @param rawData - Raw input text
     * @param category - Event category
     * @returns Generated title
     */
    private generateTitle(rawData: string, _category: LifeEventCategory): string {
        // Get first sentence or first 50 chars
        const firstSentence = rawData.split(/[.!?]/)[0] || rawData;
        const title = firstSentence.substring(0, 50).trim();

        if (title.length < rawData.length) {
            return title.endsWith("...") ? title : title + "...";
        }

        return title;
    }

    /**
     * Generates a description from raw data.
     *
     * @param rawData - Raw input text
     * @returns Cleaned description
     */
    private generateDescription(rawData: string): string {
        return rawData.trim().substring(0, 500);
    }

    /**
     * Generates relevant tags for the event.
     *
     * @param rawData - Raw input text
     * @param category - Event category
     * @param entities - Extracted entities
     * @returns Array of tags
     */
    private generateTags(
        rawData: string,
        category: LifeEventCategory,
        entities: LifeEvent["entities"]
    ): string[] {
        const tags: string[] = [category];

        // Add entity names as tags
        entities.forEach((entity) => {
            if (entity.relevance > 0.5) {
                tags.push(entity.name.toLowerCase());
            }
        });

        // Add time-based tags
        const text = rawData.toLowerCase();
        if (text.includes("morning")) tags.push("morning");
        if (text.includes("evening")) tags.push("evening");
        if (text.includes("weekend")) tags.push("weekend");

        return [...new Set(tags)].slice(0, 10);
    }

    /**
     * Calculates credit cost based on complexity.
     *
     * @param complexity - Pipeline complexity level
     * @returns Credit cost
     */
    private getCreditCost(complexity: PipelineComplexity): number {
        switch (complexity) {
            case "simple":
                return CREDIT_COSTS.FLOW_PIPELINE_SIMPLE;
            case "standard":
                return CREDIT_COSTS.FLOW_DISTILLATION;
            case "complex":
                return CREDIT_COSTS.FLOW_PIPELINE_COMPLEX;
            default:
                return CREDIT_COSTS.FLOW_DISTILLATION;
        }
    }

    /**
     * Creates a deterministic hash of the input.
     *
     * @param rawData - Raw input text
     * @param dataType - Input data type
     * @returns SHA-256 hash string
     */
    private hashInput(rawData: string, dataType: InputDataType): string {
        const data = `${dataType}|${rawData}`;
        return crypto.createHash("sha256").update(data).digest("hex").substring(0, 32);
    }

    /**
     * Generates a unique event ID.
     *
     * @returns Unique identifier
     */
    private generateEventId(): string {
        const timestamp = Date.now().toString(36);
        const random = crypto.randomBytes(4).toString("hex");
        return `evt_${timestamp}_${random}`;
    }

    /**
     * Checks cache for existing processed event.
     *
     * @param sourceHash - Hash of the input
     * @returns Cached event if exists
     */
    private async checkCache(sourceHash: string): Promise<LifeEvent | null> {
        try {
            const doc = await this.db.collection(this.cacheCollection).doc(sourceHash).get();
            if (doc.exists) {
                return doc.data() as LifeEvent;
            }
            return null;
        } catch (error) {
            logger.warn("Flow cache check failed", { error, sourceHash });
            return null;
        }
    }

    /**
     * Caches a processed event.
     *
     * @param sourceHash - Hash key
     * @param event - Event to cache
     */
    private async cacheEvent(sourceHash: string, event: LifeEvent): Promise<void> {
        try {
            await this.db.collection(this.cacheCollection).doc(sourceHash).set({
                ...event,
                cachedAt: FieldValue.serverTimestamp(),
            });
            logger.info("Event cached", { sourceHash, eventId: event.id });
        } catch (error) {
            logger.warn("Failed to cache event", { error, sourceHash });
        }
    }

    /**
     * Stores event in user's Firestore collection.
     *
     * @param userId - User ID
     * @param event - Event to store
     */
    private async storeEvent(userId: string, event: LifeEvent): Promise<void> {
        try {
            await this.db
                .collection(`users/${userId}/${this.eventsCollection}`)
                .doc(event.id)
                .set(event);
            logger.info("Event stored for user", { userId, eventId: event.id });
        } catch (error) {
            logger.error("Failed to store event", { error, userId, eventId: event.id });
        }
    }
}

/** Singleton instance */
let _flowInstance: FlowService | null = null;

/**
 * Gets the singleton FlowService instance.
 *
 * @returns The global FlowService instance
 */
export function getFlowService(): FlowService {
    if (!_flowInstance) {
        _flowInstance = new FlowService();
    }
    return _flowInstance;
}
