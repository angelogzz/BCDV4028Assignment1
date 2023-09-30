// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20A {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract TokenA is IERC20A {
    uint public override totalSupply;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;
    string public name = "TokenA";
    string public symbol = "Token A";
    uint8 public decimals; // Declare decimals here

    constructor() {
        totalSupply = 1000000000000000000000000; // Mint 1,000,000 tokens
        balanceOf[msg.sender] = totalSupply;
        decimals = 18; // Set the number of decimals
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(
        address recipient,
        uint amount
    ) external override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            balanceOf[msg.sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(
        address spender,
        uint amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external override returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            balanceOf[sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        require(
            allowance[sender][msg.sender] >= amount,
            "ERC20: transfer amount exceeds allowance"
        );

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
