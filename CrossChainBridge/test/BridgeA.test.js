// BridgeA.test.js
const BridgeA = artifacts.require("BridgeA");
const TokenA = artifacts.require("TokenA");

contract("BridgeA", (accounts) => {
  let bridgeAInstance;
  let tokenAInstance;

  before(async () => {
    tokenAInstance = await TokenA.new();
    bridgeAInstance = await BridgeA.new(tokenAInstance.address);
  });

  it("should lock and mint tokens", async () => {
    const amount = web3.utils.toWei("10", "ether");
    await tokenAInstance.approve(bridgeAInstance.address, amount, {
      from: accounts[0],
    });

    await bridgeAInstance.lockTokens(amount, { from: accounts[0] });
    const balanceBefore = await tokenAInstance.balanceOf(accounts[1]);
    await bridgeAInstance.mintTokens(accounts[1], amount, {
      from: accounts[0],
    });
    const balanceAfter = await tokenAInstance.balanceOf(accounts[1]);

    assert.equal(
      balanceBefore.toString(),
      "0",
      "Balance should be 0 before minting"
    );
    assert.equal(
      balanceAfter.toString(),
      amount,
      "Balance should be the locked amount after minting"
    );
  });
});
