require('dotenv').config();
const API_URL = process.env.API_URL;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const contract = require("../artifacts/contracts/flooredNFT.sol/FlooredApe.json");
const contractAddress = "0x4bCe72C8D60c365dB439253f2e2866416929A519";
const nftContract = new web3.eth.Contract(contract.abi, contractAddress);
 
async function main() {
  nftContract.renounce();
}
