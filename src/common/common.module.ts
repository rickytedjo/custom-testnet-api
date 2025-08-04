import { Global, Module } from "@nestjs/common";
import { ProviderService } from "./utils";
import { ConfigModule } from "@nestjs/config";

@Global()
@Module({
  imports: [ConfigModule],
  providers: [
    ProviderService
  ],
  exports: [
    ProviderService
  ],
})
export class CommonModule {}   