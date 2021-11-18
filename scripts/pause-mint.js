require('dotenv').config();
const API_URL = process.env.API_URL;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const contract = require("../artifacts/contracts/flooredNFT.sol/FlooredApe.json");
const contractAddress = "0xD5096d756bF5072A3120205d4f763Df17d65a786";
const nftContract = new web3.eth.Contract(contract.abi, contractAddress);

async function pause()
{
  try{
    const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce
  const tx = {
    'from': PUBLIC_KEY,
    'to': contractAddress,
    'nonce': nonce,
    'gas': 500000,
    'maxPriorityFeePerGas': 1999999987,
    'data': nftContract.methods.pause().encodeABI()
  };
  const signPromise = await web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
  console.log(signPromise)

  } catch(err) {
    console.log(err)
  }
  
}

async function unpause()
{
  try{
    const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce
  const tx = {
    'from': PUBLIC_KEY,
    'to': contractAddress,
    'nonce': nonce,
    'gas': 500000,
    'maxPriorityFeePerGas': 1999999987,
    'data': nftContract.methods.unpause().encodeABI()
  };
  const signPromise = await web3.eth.accounts.signTransaction(tx, PRIVATE_KEY);
  console.log(signPromise)

  } catch(err) {
    console.log(err)
  }
  
}
pause();
//unpause();