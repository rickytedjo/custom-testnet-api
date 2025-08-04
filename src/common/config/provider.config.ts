import { registerAs } from "@nestjs/config";
import { NetworkProvider } from "../types";

export default registerAs<NetworkProvider>('NetworkProvider', ()=>({
    providerUrl: process.env.NETWORK_PROVIDER || null,
    walletKey: process.env.WALLET_KEY || null,
}));