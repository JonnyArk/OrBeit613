import { Request } from "express";
export type TypedResponse<T = any> = {
    status(code: number): TypedResponse<T>;
    json(data: T): void;
    send(data: string): void;
};
export declare function requireAuth(req: Request, res: TypedResponse): Promise<string | null>;
//# sourceMappingURL=auth.d.ts.map