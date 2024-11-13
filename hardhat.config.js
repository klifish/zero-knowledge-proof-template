require("@nomicfoundation/hardhat-toolbox");
const path = require("path");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version:"0.8.27",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: { 
    localhost: {
      url: "http://127.0.0.1:8545",
      allowUnlimitedContractSize: true, // @kun For testing purposes, we allow unlimited contract sizes
    }
  },  
};
