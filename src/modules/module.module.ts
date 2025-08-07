import { Module } from "@nestjs/common";
import { DeployerModule } from "./deployer/deployer.module";

@Module({
  imports: [DeployerModule]
})
export class ModulesModule {}