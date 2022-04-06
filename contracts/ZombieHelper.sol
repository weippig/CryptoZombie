//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }

  // 2. 在这里创建 setLevelUpFee 函数 
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    zombies[_zombieId].level++;
  }
  
  function changeName(uint _zombieId, string memory _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId){
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // 在这里开始
    uint counter = 0;
    for(uint i = 0; i < zombies.length; i++) {
      if(zombieToOwner[i]== _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}