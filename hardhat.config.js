/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
const { API_URL, PRIVATE_KEY } = process.env;
module.exports = {
   solidity: "0.8.2",
   defaultNetwork: "rinkeby",
   networks: {
      hardhat: {},
      rinkeby: {
         url: API_URL,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
   etherscan: {
      // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "3SBPY4PF1ITK3FRM338Z5ZNS8M2UUY8SCF"
   }
}