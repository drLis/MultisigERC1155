pragma solidity ^0.8.0;

import "./_lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract ShardedToken is Ownable
{
	event TransferToken(address indexed from, address indexed to, uint256 id, uint256 value);
	event Transfer(address indexed from, address indexed to, uint value);

	mapping (uint => mapping (address => uint)) public balances;

	constructor () Ownable()
	{

	}

	function balanceOf(address owner, uint id) public returns (uint)
	{
		return balances[id][owner];
	}

	function mint(address who, uint id, uint value) onlyOwner public
	{
		balances[id][who] += value;

		emit TransferToken(address(0), who, id, value);
		emit Transfer(address(0), who, value);
	}

	function transfer(address to, uint[] calldata ids, uint[] calldata values) public
	{
		uint totalTransfered = 0;

		for (uint i = 0; i < ids.length; i++)
		{
			uint balance = balances[ids[i]][msg.sender];
			if (balance >= values[i])
			{
				balances[ids[i]][msg.sender] -= values[i];
				balances[ids[i]][to] += values[i];

				totalTransfered += values[i];

				emit TransferToken(msg.sender, to, ids[i], values[i]);
			}
		}

		emit Transfer(msg.sender, to, totalTransfered);
	}
}