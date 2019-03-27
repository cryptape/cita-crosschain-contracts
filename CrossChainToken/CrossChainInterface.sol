pragma solidity ^0.4.24;

import "./Owned.sol";
import "./CrossChainChecker.sol";

contract CrossChainInterface is CrossChainChecker, Owned {
    event Issue(address indexed _to, uint256 _value);
    event Burn(address indexed _account, uint256 _value);

    function issue(address to, uint256 value) public returns (bool success);
    function burn() public returns (bool success);
}
