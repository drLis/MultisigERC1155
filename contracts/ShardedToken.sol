pragma solidity ^0.8.0;

import "./_lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ShardedToken is Ownable
{
	event TransferToken(address indexed from, address indexed to, uint256 series, uint256 value);
	event Transfer(address indexed from, address indexed to, uint value);

	mapping (uint => mapping (address => uint)) public balances;

	constructor () Ownable()
	{

	}

	function balanceOf(address owner, uint series) public returns (uint)
	{
		return balances[series][owner];
	}

	function mint(address who, uint series, uint value) onlyOwner public
	{
		balances[series][who] += value;

		emit TransferToken(address(0), who, series, value);
		emit Transfer(address(0), who, value);
	}

	function transfer(address to, uint[] calldata series, uint[] calldata values) public
	{
		uint totalTransfered = 0;

		for (uint i = 0; i < series.length; i++)
		{
			uint balance = balances[series[i]][msg.sender];
			if (balance >= values[i])
			{
				balances[series[i]][msg.sender] -= values[i];
				balances[series[i]][to] += values[i];

				totalTransfered += values[i];

				emit TransferToken(msg.sender, to, series[i], values[i]);
			}
		}

		emit Transfer(msg.sender, to, totalTransfered);
	}
}