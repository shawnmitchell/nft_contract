const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy(100);
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);
  const remaining = await nftContract.remainingEpicNFTs();
  console.log("NFTs remaining: ", remaining);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();