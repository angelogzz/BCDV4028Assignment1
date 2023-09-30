// BridgeB.test.js
const BridgeB = artifacts.require("BridgeB");
const TokenB = artifacts.require("TokenB");

contract("BridgeB", (accounts) => {
  let bridgeBInstance;
  let tokenBInstance;

  before(async () => {
    tokenBInstance = await TokenB.new();
    bridgeBInstance = await BridgeB.new(tokenBInstance.address);
  });

  it("should lock and mint tokens", async () => {
    const amount = web3.utils.toWei("10", "ether");
    await tokenBInstance.approve(bridgeBInstance.address, amount, {
      from: accounts[0],
    });

    await bridgeBInstance.lockTokens(amount, { from: accounts[0] });
    const balanceBefore = await tokenBInstance.balanceOf(accounts[1]);
    await bridgeBInstance.mintTokens(accounts[1], amount, {
      from: accounts[0],
    });
    const balanceAfter = await tokenBInstance.balanceOf(accounts[1]);

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
