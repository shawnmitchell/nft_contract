const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy(100);
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  const data = await nftContract.getURI(1);
  console.log("----------------------------- getURI -------------------------");
  console.log(data);
  console.log("----------------------------- getURI -------------------------");
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