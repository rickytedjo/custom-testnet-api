import { registerAs } from "@nestjs/config";
import { Database } from "../types";

export default registerAs<Database>('Database', () => ({
    url: process.env.DATABASE_URL || null,
}));