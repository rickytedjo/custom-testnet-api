import { Module } from '@nestjs/common';
import { ModulesModule } from './modules/module.module';
import { CoreModule } from './core/core.module';
import { CommonModule } from './common/common.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule.forRoot({isGlobal:true}),
    CommonModule,
    CoreModule,
    ModulesModule 
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
