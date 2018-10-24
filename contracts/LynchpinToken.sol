pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

interface ERC20
{
	function totalSupply() view external returns (uint _totalSupply);
	function balanceOf(address _owner) view external returns (uint balance);
	function transfer(address _to, uint _value) external returns (bool success);
	function transferFrom(address _from, address _to, uint _value) external returns (bool success);
	function approve(address _spender, uint _value) external returns (bool success);
	function allowance(address _owner, address _spender) view external returns (uint remaining);

	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract LynchpinToken is ERC20
{
	using SafeMath for uint256;

	string 	public name        = "Lynchpin";
	string 	public symbol      = "LYN";
	uint8 	public decimals    = 18;
	uint 	public totalSupply = 5000000 * (10 ** uint(decimals));
	address public owner       = 0x18C9801811661Dce734644FF0A3aeFd43aD17908; // to be UPDATED

	mapping (address => uint) public balanceOf;
	mapping (address => mapping (address => uint)) public allowance;

	constructor() public
	{
		balanceOf[owner] = totalSupply;
	}

	function totalSupply() view external returns (uint _totalSupply)
	{
		return totalSupply;
	}

	function balanceOf(address _owner) view external returns (uint balance)
	{
		return balanceOf[_owner];
	}

	function allowance(address _owner, address _spender) view external returns (uint remaining)
	{
		return allowance[_owner][_spender];
	}
	function _transfer(address _from, address _to, uint _value) internal
	{
		require(_to != 0x0);

		uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
		balanceOf[_from] = balanceOf[_from].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);

		emit Transfer(_from, _to, _value);
		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
	}

	function transfer(address _to, uint _value) public returns (bool success)
	{
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint _value) public returns (bool success)
	{
		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
		_transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint _value) public returns (bool success)
	{
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	// disallow incoming ether to this contract
	function () public
	{
		revert();
	}
}
