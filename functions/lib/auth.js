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
exports.withAuthAndCors = withAuthAndCors;
const auth_1 = require("firebase-admin/auth");
const logger = __importStar(require("firebase-functions/logger"));
// eslint-disable-next-line @typescript-eslint/no-require-imports
const cors = require("cors");
const corsHandler = cors({ origin: true });
async function requireAuth(req) {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
        throw new Error("Unauthorized: Missing or invalid token");
    }
    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await (0, auth_1.getAuth)().verifyIdToken(idToken);
        return { uid: decodedToken.uid };
    }
    catch (error) {
        logger.error("Authentication failed", { error });
        throw new Error("Unauthorized: Invalid token");
    }
}
function withAuthAndCors(handler) {
    return (req, res) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        corsHandler(req, res, () => {
            (async () => {
                try {
                    await requireAuth(req);
                    await handler(req, res);
                }
                catch (error) {
                    if (!res.headersSent) {
                        logger.error("Request failed in withAuthAndCors", { error });
                        const msg = error instanceof Error ? error.message : "Unknown error";
                        const status = msg.startsWith("Unauthorized") ? 401 : 500;
                        res.status(status).json({ success: false, error: msg });
                    }
                }
            })();
        });
    };
}
//# sourceMappingURL=auth.js.map