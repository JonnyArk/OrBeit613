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
async function requireAuth(request, response) {
    // Allow CORS preflight requests
    if (request.method === "OPTIONS") {
        response.set("Access-Control-Allow-Origin", "*");
        response.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.set("Access-Control-Allow-Headers", "Authorization, Content-Type");
        response.status(204).send("");
        return null;
    }
    const authHeader = request.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        logger.warn("Unauthorized request missing Bearer token");
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await (0, auth_1.getAuth)().verifyIdToken(token);
        request.user = decodedToken;
        return decodedToken;
    }
    catch (error) {
        logger.error("Error verifying Firebase ID token", { error });
        response.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
//# sourceMappingURL=auth.js.map