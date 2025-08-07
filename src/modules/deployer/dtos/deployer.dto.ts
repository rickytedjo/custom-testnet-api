import { Transform } from "class-transformer";
import { IsNotEmpty, IsString } from "class-validator";

export class DeployerDto {
    @IsNotEmpty({ message: 'Contract name is required' })
    @IsString({ message: 'Contract name must be a string' })
    @Transform(({ value }) => value.toString())
    contractName: string;
}