import { Global, Module } from "@nestjs/common";
import { PostgresService } from "./psql/postgres.service";
import { PostgresModule } from "./psql/postgres.module";
import { ConfigModule } from "@nestjs/config";
import providerConfig from "src/common/config/provider.config";
import dbConfig from "src/common/config/db.config";

@Global()
@Module({
    imports: [
        ConfigModule.forRoot({
            isGlobal: true,
            load: [
                dbConfig,
                providerConfig
            ],
            cache: true,
            expandVariables: true,
        }),
        PostgresModule
    ],
    exports: [PostgresModule],
})

export class CoreModule {}