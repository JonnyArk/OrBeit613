"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.requireAuth = requireAuth;
const auth_1 = require("firebase-admin/auth");
async function requireAuth(req, res) {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
    const token = authHeader.substring(7);
    try {
        const decodedToken = await (0, auth_1.getAuth)().verifyIdToken(token);
        return decodedToken.uid;
    }
    catch {
        res.status(401).json({ error: "Unauthorized" });
        return null;
    }
}
//# sourceMappingURL=auth.js.map