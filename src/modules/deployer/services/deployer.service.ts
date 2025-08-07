import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { ProviderService } from "src/common/utils";
import { PostgresService } from "src/core/psql/postgres.service";
import { DeployerDto } from "../dtos";
import { ethers } from "ethers";
import { Contract } from "../types";

@Injectable()
export class DeployerService {
  constructor(
    private readonly config: ConfigService,
    private readonly db: PostgresService,
    private readonly provider: ProviderService
  ){}

  async createContract(dto: DeployerDto) {
    try{
        const { provider, wallet } = await this.provider.getProviderAndWallet();
        if (!provider  || !wallet) {
            throw new Error('Provider or wallet not initialized');
        }

        const {abi, bytecode} = await this.provider.getAbiAndBytecode();
        if (!abi) {
            throw new Error('ABI not found');
        }

        const contract = new ethers.ContractFactory(
            abi,
            bytecode,
            wallet
        );

        const contractInstance = await contract.deploy( dto.contractName ,{
            value: ethers.toBigInt(0),
            maxFeePerGas: 1000n,
            maxPriorityFeePerGas: 0n,
            gasLimit: 3_000_000,
            chainId: (await provider.getNetwork()).chainId,
        });

        await contractInstance.waitForDeployment();
        const deployedAddress = await contractInstance.getAddress();

        const contractData: Contract = {
            contractaddress: deployedAddress,
            useraddress: wallet.address.toLowerCase(),
        }

        await this.db.insert<Contract>('contracts', contractData);

        return {
            status: 'success',
            message: 'Contract created successfully at address: ' + deployedAddress,
        };

    } catch (error) {
        return {
            statusCode: error.statusCode,
            message: error.message || 'Contract creation failed',
        };
    }
  }

  async getContracts() {
    const { provider, wallet } = await this.provider.getProviderAndWallet();
        if (!provider  || !wallet) {
            throw new Error('Provider or wallet not initialized');
        }

        const contractList = await this.db.getAll<Contract>('contracts', {
            useraddress: wallet.address.toLowerCase(),
        });

        if (contractList.length === 0) {
            return 'No contracts found';
        }

        const { abi } = await this.provider.getAbiAndBytecode();
        if (!abi) {
            throw new Error('ABI not found');
        }

        const contractsWithTx = await Promise.all(contractList.map(async contract => {
            const contractInstance = new ethers.Contract(contract.contractaddress, abi, provider);
            let contractName = '';
            try {
                contractName = await contractInstance.getName();
            } catch (err) {
                contractName = 'Unknown';
            }
            return {
                contractAddress: contract.contractaddress,
                contractName,
                contractBalance: (await provider.getBalance(contract.contractaddress)).toString()
            };
        }));

        return contractsWithTx;
  }
}