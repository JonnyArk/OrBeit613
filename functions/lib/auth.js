"use strict";
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
Object.defineProperty(exports, "__esModule", { value: true });
exports.requireAuth = requireAuth;
const auth_1 = require("firebase-admin/auth");
const logger = __importStar(require("firebase-functions/logger"));
/**
 * Validates the Firebase ID token in the authorization header.
 *
 * @param request The incoming HTTP request
 * @param response The HTTP response object
 * @returns A promise that resolves to true if authorized, false otherwise
 */
async function requireAuth(request, response) {
    // Allow CORS preflight requests
    if (request.method === "OPTIONS") {
        return true;
    }
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request: Missing or invalid authorization header");
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        await (0, auth_1.getAuth)().verifyIdToken(token);
        return true;
    }
    catch (error) {
        logger.error("Unauthorized request: Token verification failed", { error: error instanceof Error ? error.message : "Unknown error" });
        response.status(401).json({ error: "Unauthorized" });
        return false;
    }
}
//# sourceMappingURL=auth.js.map