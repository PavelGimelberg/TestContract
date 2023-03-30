require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan"); 

const { projectId, privateKey, etherscanApiKey } = require('./secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
      chainId: 1337
    },
    fantomTestnet: {
      url: `https://rpc.testnet.fantom.network`,
      chainId: 4002,
      gasPrice: 22000000000,
      accounts: [privateKey],
    },
  },
  etherscan: {
     apiKey: etherscanApiKey,
     chainId: 4002
  },
};

