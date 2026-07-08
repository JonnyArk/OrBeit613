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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.withAuth = void 0;
const cors_1 = __importDefault(require("cors"));
const auth_1 = require("firebase-admin/auth");
const logger = __importStar(require("firebase-functions/logger"));
const corsHandler = (0, cors_1.default)({ origin: true });
const withAuth = (handler) => {
    return (req, res) => {
        corsHandler(req, res, async () => {
            try {
                const authHeader = req.headers.authorization;
                if (!authHeader || !authHeader.startsWith("Bearer ")) {
                    logger.warn("Missing or invalid authorization header");
                    res.status(401).json({ success: false, error: "Unauthorized" });
                    return;
                }
                const idToken = authHeader.split("Bearer ")[1];
                let decodedToken;
                try {
                    decodedToken = await (0, auth_1.getAuth)().verifyIdToken(idToken);
                }
                catch (error) {
                    logger.warn("Invalid ID token", { error });
                    res.status(401).json({ success: false, error: "Unauthorized" });
                    return;
                }
                await handler(req, res, decodedToken.uid);
            }
            catch (error) {
                logger.error("Unhandled error in secure endpoint", { error });
                res.status(500).json({ success: false, error: "Internal Server Error" });
            }
        });
    };
};
exports.withAuth = withAuth;
//# sourceMappingURL=auth.js.map