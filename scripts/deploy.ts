import { ethers } from "hardhat";

async function main() {

  const digitalWallet = await ethers.deployContract("DigitalWallet");

  await digitalWallet.waitForDeployment();

  console.log("DigitalWallet deployed to : ",await digitalWallet.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
