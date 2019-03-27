pragma solidity ^0.4.24;

import "./SafeMath.sol";
import "./ERC20Interface.sol";
import "./CrossChainInterface.sol";

contract CrossChainToken is ERC20Interface, CrossChainInterface {

    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) _balances;
    mapping(address => mapping(address => uint)) _allowed;

    // to (address) + value (uint)
    uint _dataSize = 0x40;

    constructor() public {
        symbol = "CCT";
        name = "CrossChain Token";
        decimals = 18;
        _totalSupply = 0;
    }

    function () external payable {
        revert();
    }

    /*
     * ERC20
     */

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return _balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        _balances[_from] = _balances[_from].sub(_value);
        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return _allowed[_owner][_spender];
    }

    /*
     * CrossChain
     */

    function issue(address to, uint256 value) onlyOwner public returns (bool success) {
        _totalSupply = _totalSupply.add(value);
        _balances[to] = _balances[to].add(value);
        emit Issue(to, value);
        return true;
    }

    function burn() public returns (bool success) {
        uint256 amount = _balances[msg.sender];
        _totalSupply = _totalSupply.sub(_balances[msg.sender]);
        _balances[msg.sender] = 0;
        emit Burn(msg.sender, amount);
        return true;
    }
}
