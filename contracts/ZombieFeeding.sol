//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ZombieFactory.sol";

//如果我们的合约需要和区块链上的其他的合约会话，则需先定义一个 interface (接口)。
//在我们的 app 代码中使用这个接口，合约就知道其他合约的函数是怎样的，应该如何调用，以及可期待什么类型的返回值。
abstract contract KittyInterface {
    function getKitty(uint256 _id) external view virtual returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

//因為factory是Ownable，所以他也是
contract ZombieFeeding is ZombieFactory {
    // Initialize kittyContract 
    KittyInterface kittyContract;
    function setKittyContractAddress(address _address) external onlyOwner{
        kittyContract = KittyInterface(_address);
    }

    modifier ownerOf(uint _zombieId) {
        require( msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory species) internal ownerOf(_zombieId) {

        Zombie storage myZombie = zombies[_zombieId];
        require( _isReady(myZombie));

        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if ( keccak256(abi.encodePacked(species)) == keccak256(abi.encodePacked("kitty"))) {
            newDna = newDna - (newDna % 100) + 99;
        }

        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        //會回傳10個值，但是只想要最後一個
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty"); 
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }
    
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }
}


//internal 和 private 类似，不过， 如果某个合约继承自其父合约，这个合约即可以访问父合约中定义的“内部”函数。
//external 与public 类似，只不过这些函数只能在合约之外调用 - 它们不能被合约内的其他函数调用。稍后我们将讨论什么时候使用