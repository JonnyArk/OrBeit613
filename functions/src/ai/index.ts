/**
 * OrBeit AI Module - Barrel Export
 *
 * @packageDocumentation
 * @module ai
 *
 * Re-exports all AI services for convenient importing.
 */

// Core AI Manager
export {
    AIManager,
    getAIManager,
    CREDIT_COSTS,
    type AIService,
    type CreditUsageEntry,
    type CreditCheckResult,
} from "./ai_manager";

// Whisk Service (Asset Generation)
export {
    WhiskService,
    getWhiskService,
    type AssetType,
    type AssetSize,
    type AssetGenerationRequest,
    type AssetGenerationResponse,
} from "./whisk_service";

// Flow Service (Workflow Pipelines)
export {
    FlowService,
    getFlowService,
    type InputDataType,
    type PipelineComplexity,
    type LifeEventCategory,
    type LifeEvent,
    type DistillationRequest,
    type DistillationResponse,
} from "./flow_service";
