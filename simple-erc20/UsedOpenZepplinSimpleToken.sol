// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
  constructor(string memory _name, string memory _symbol, uint _amount) ERC20(_name, _symbol) {
    _mint(msg.sender, _amount * 10 * uint(decimals())); // ex) 1 Token = 1 * 10^18;
  }
}