const { expect, assert } = require("chai");
const { ethers } = require("hardhat");
const utils = require("./helpers/utils");

const zombieNames = ["Zombie 1", "Zombie 2"];

describe("CryptoZombie",async function () {
    let cryptoZombieInstance;

    beforeEach(async () => {
        const CryptoZombie = await ethers.getContractFactory("ZombieFactory");
        cryptoZombieInstance = await CryptoZombie.deploy()
        await cryptoZombieInstance.deployed();
    });

    it("should be able to create a new zombie", async function() { 
        let alice = await ethers.getSigner()
        const result = await cryptoZombieInstance.createRandomZombie(zombieNames[0], {from: alice.address})
    })

    xcontext("with the single-step transfer scenario", async () => {
        it("should transfer a zombie", async () => {
            const result = await cryptoZombieInstance.createRandomZombie(zombieNames[0], {from: alice.address});
            await cryptoZombieInstance.transferFrom(alice.address, bob.address, zombieId, {from: alice});
        })
    })
    xcontext("with the two-step transfer scenario", async () => {
        it("should approve and then transfer a zombie when the approved address calls transferFrom", async () => {
          // TODO: Test the two-step scenario.  The approved address calls transferFrom
        })
        it("should approve and then transfer a zombie when the owner calls transferFrom", async () => {
            // TODO: Test the two-step scenario.  The owner calls transferFrom
         })
    })
})



// describe("Greeter", function () {
//   it("Should return the new greeting once it's changed", async function () {
//     const Greeter = await ethers.getContractFactory("Greeter");
//     const greeter = await Greeter.deploy("Hello, world!");
//     await greeter.deployed();

//     expect(await greeter.greet()).to.equal("Hello, world!");

//     const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

//     // wait until the transaction is mined
//     await setGreetingTx.wait();

//     expect(await greeter.greet()).to.equal("Hola, mundo!");
//   });
// });
