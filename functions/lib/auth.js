"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.requireAuth = requireAuth;
const auth_1 = require("firebase-admin/auth");
const v2_1 = require("firebase-functions/v2");
// eslint-disable-next-line @typescript-eslint/no-explicit-any
async function requireAuth(req) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        v2_1.logger.warn("Missing or invalid authorization header");
        return false;
    }
    const idToken = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await (0, auth_1.getAuth)().verifyIdToken(idToken);
        req.user = decodedToken;
        return true;
    }
    catch (error) {
        v2_1.logger.error("Error verifying Firebase ID token:", error);
        return false;
    }
}
//# sourceMappingURL=auth.js.map