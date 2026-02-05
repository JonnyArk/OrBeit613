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
/**
 * Supported input data types for processing.
 */
export type InputDataType = "sensor_data" | "note_text" | "voice_transcript" | "location_context" | "calendar_event" | "health_metric";
/**
 * Pipeline complexity levels affecting credit cost.
 */
export type PipelineComplexity = "simple" | "standard" | "complex";
/**
 * Life Event categories for Drift database storage.
 */
export type LifeEventCategory = "task" | "memory" | "health" | "location" | "relationship" | "achievement" | "reflection" | "routine";
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
        coordinates?: {
            x: number;
            y: number;
        };
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
        score: number;
        magnitude: number;
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
export declare class FlowService {
    private readonly db;
    private readonly aiManager;
    private readonly cacheCollection;
    private readonly eventsCollection;
    /**
     * Creates a new FlowService instance.
     */
    constructor();
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
    distillContext(request: DistillationRequest): Promise<DistillationResponse>;
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
    private runSovereignPipeline;
    /**
     * Infers the category of the Life Event from content.
     *
     * @param rawData - Raw input text
     * @param dataType - Input data type
     * @returns Inferred category
     */
    private inferCategory;
    /**
     * Extracts named entities from text.
     *
     * @param rawData - Raw input text
     * @returns Array of extracted entities
     */
    private extractEntities;
    /**
     * Analyzes sentiment of the input text.
     *
     * @param rawData - Raw input text
     * @returns Sentiment analysis result
     */
    private analyzeSentiment;
    /**
     * Extracts action items from text.
     *
     * @param rawData - Raw input text
     * @returns Array of action items
     */
    private extractActionItems;
    /**
     * Generates a concise title for the event.
     *
     * @param rawData - Raw input text
     * @param category - Event category
     * @returns Generated title
     */
    private generateTitle;
    /**
     * Generates a description from raw data.
     *
     * @param rawData - Raw input text
     * @returns Cleaned description
     */
    private generateDescription;
    /**
     * Generates relevant tags for the event.
     *
     * @param rawData - Raw input text
     * @param category - Event category
     * @param entities - Extracted entities
     * @returns Array of tags
     */
    private generateTags;
    /**
     * Calculates credit cost based on complexity.
     *
     * @param complexity - Pipeline complexity level
     * @returns Credit cost
     */
    private getCreditCost;
    /**
     * Creates a deterministic hash of the input.
     *
     * @param rawData - Raw input text
     * @param dataType - Input data type
     * @returns SHA-256 hash string
     */
    private hashInput;
    /**
     * Generates a unique event ID.
     *
     * @returns Unique identifier
     */
    private generateEventId;
    /**
     * Checks cache for existing processed event.
     *
     * @param sourceHash - Hash of the input
     * @returns Cached event if exists
     */
    private checkCache;
    /**
     * Caches a processed event.
     *
     * @param sourceHash - Hash key
     * @param event - Event to cache
     */
    private cacheEvent;
    /**
     * Stores event in user's Firestore collection.
     *
     * @param userId - User ID
     * @param event - Event to store
     */
    private storeEvent;
}
/**
 * Gets the singleton FlowService instance.
 *
 * @returns The global FlowService instance
 */
export declare function getFlowService(): FlowService;
//# sourceMappingURL=flow_service.d.ts.map