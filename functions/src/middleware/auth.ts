import { getAuth } from "firebase-admin/auth";
import cors from "cors";

const corsHandler = cors({ origin: true });

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type TypedResponse = any;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const withAuth = (handler: (request: any, response: TypedResponse, uid: string) => Promise<void>) => {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return async (request: any, response: TypedResponse) => {
        corsHandler(request, response, async () => {
            const auth = request.headers.authorization;
            if (!auth?.startsWith("Bearer ")) {
                response.status(401).json({ error: "Unauthorized" });
                return;
            }
            try {
                const decodedToken = await getAuth().verifyIdToken(auth.split("Bearer ")[1]);
                await handler(request, response, decodedToken.uid);
            } catch (_error) {
                response.status(401).json({ error: "Unauthorized" });
            }
        });
    };
};
