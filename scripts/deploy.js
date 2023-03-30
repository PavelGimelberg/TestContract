const hre = require('hardhat');

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log('Deploying contracts with the account:', deployer.address);

  const CustomNFT = await hre.ethers.getContractFactory('CustomNFT');
  const customNFT = await CustomNFT.deploy('CustomNFT', 'CNFT');

  console.log('CustomNFT deployed to:', customNFT.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

