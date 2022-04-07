//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZombieFactory is Ownable{
    struct Zombie {
        string name;
        uint dna;
        uint32 level; //使用uint32較uint省空間且便宜、另外，盡量把相同data type放一起
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    event NewZombie(uint zombieId, string name, uint dna);

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;
    Zombie[] public zombies;
    
    //私有函数的名字用(_)起始。
    //习惯上函数里的变量都是以(_)开头 (但不是硬性规定) 以区别全局变量。我们整个教程都会沿用这个习惯。
    //為了讓子合約使用，不用Private而是改用internal
    function _createZombie(string memory _name, uint _dna) internal {
        zombies.push(Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0));

        uint id = zombies.length - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;

        emit NewZombie(id, _name, _dna);
    }

    // keccak256為SHA-3的版本號，並沒有真正安全產生隨機數的方式！不過對產生dna已經足夠
    // uint是uint256的別名
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    //require使得函数在执行过程中，当不满足某些条件时抛出错误，并停止执行
    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "owner already has a zombie!");
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

//Storage 变量是指永久存储在区块链中的变量。
// Memory 变量则是临时的，当外部函数对某合约调用完成时，内存型变量即被移除。
//你可以把它想象成存储在你电脑的硬盘或是RAM中数据的关系。
