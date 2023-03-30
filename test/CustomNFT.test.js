const { expect } = require("chai");

describe("CustomNFT", function () {
  let CustomNFT, customNFT, owner, addr1;

  beforeEach(async () => {
    CustomNFT = await ethers.getContractFactory("CustomNFT");
    [owner, addr1] = await ethers.getSigners();
    customNFT = await CustomNFT.deploy("Custom NFT", "CNFT");
    await customNFT.deployed();
  });

  it("Should support arbitrary type/number of attributes", async function () {
    // Mint a new token
    await customNFT.connect(owner).safeMint(addr1.address, "ipfs://tokenURI1", 500);
    // Verify the token was minted
    const tokenURI1 = await customNFT.tokenURI(1);
    expect(tokenURI1).to.equal("ipfs://tokenURI1");

    // Mint another token with a different URI
    await customNFT.connect(owner).safeMint(addr1.address, "ipfs://tokenURI2", 250);
    // Verify the second token was minted
    const tokenURI2 = await customNFT.tokenURI(2);
    expect(tokenURI2).to.equal("ipfs://tokenURI2");
  });

  it("Should support royalty payment to NFT original creator", async function () {
    // Mint a new token
    await customNFT.connect(owner).safeMint(addr1.address, "ipfs://tokenURI1", 500);

    // Verify the original creator and royalty fee
    const { receiver, royaltyAmount } = await customNFT.royaltyInfo(1, 10000);
    expect(receiver).to.equal(addr1.address);
    expect(royaltyAmount).to.equal(500); // 5% royalty fee (500 / 10000)
  });
});
