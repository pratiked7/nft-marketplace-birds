require("@nomiclabs/hardhat-waffle");

const projectId = "5Ycrb3zQ_BcAtdFNHUHLbr6quHVw-gdN";

module.exports = {
  defaultNetwork: "hardhat",
  networks:{
    hardhat:{
      chainId: 1337 //standard config
    },
    mumbai:{
      //used alchemy node service instead of infura due to credit card requirement
      url: `https://polygon-mumbai.g.alchemy.com/v2/${projectId}`,
      accounts:[]
    },
    mainnet: {
      url:`https://polygon-mainnet.g.alchemy.com/v2/${projectId}`,
      accounts:[]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
};
