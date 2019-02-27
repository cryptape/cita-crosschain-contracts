pragma solidity ^0.4.24;

import "./Owned.sol";
import "./CrossChainChecker.sol";

contract CrossChainInterface is CrossChainChecker, Owned {
    event Issue(address indexed _to, uint _value);
    event Burn(address indexed _account);

    function issue(bytes _proof) public returns (bool success);
    function burn(address _account) public returns (bool success);
}
