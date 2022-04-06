# Basic Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

### 關於Solidity
private 只有合約內部可以用->internal 繼承的子合約也可用
external 只能從外部調用 -> public 內外都可調用
view 不更改保存數據 -> pure 不更改保存也不讀寫 (兩者外部調用不需要gas fee)# CryptoZombie
