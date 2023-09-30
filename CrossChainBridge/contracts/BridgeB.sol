// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenB.sol";

contract BridgeB {
    TokenB public tokenContract;
    address public owner;

    constructor(TokenB _tokenContract) {
        tokenContract = _tokenContract;
        owner = msg.sender;
    }

    function lockTokens(uint256 amount) external {
        require(
            tokenContract.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
    }

    function mintTokens(address recipient, uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        tokenContract.transfer(recipient, amount);
    }
}
