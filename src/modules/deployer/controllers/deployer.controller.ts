import { Body, Controller, Get, Post } from "@nestjs/common";
import { DeployerService } from "../services";
import { ConfigService } from "@nestjs/config";
import { DeployerDto } from "../dtos";

@Controller('contract')
export class DeployerController {
  constructor(
    private readonly service: DeployerService,
    private readonly config: ConfigService,
  ){}
  
  @Post()
  async createContract(@Body() dto: DeployerDto) {
    return this.service.createContract(dto);
  }

  @Get()
  async getContracts(){
    return this.service.getContracts();
  }

  
}