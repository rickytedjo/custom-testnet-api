import { Module } from "@nestjs/common";
import { DeployerController } from "./controllers";
import { DeployerService } from "./services";

@Module({
    imports: [],
    controllers: [DeployerController],
    providers: [DeployerService],
    exports: [],
})
export class DeployerModule {}