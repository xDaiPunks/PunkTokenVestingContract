# Punk Vesting Contract

## $PUNK vesting
Of the total $PUNK total supply, which is 200.000.000 $PUNK, 100.000.000 (50%) will be "airdropped" on the Punk NFTs. 

10.000 $PUNK will be locked-up in every Punk NFT. You will be able to claim $PUNK spread-out over 20-36 months. This is called vesting. Vesting happens every block. Every 5 seconds a portion of the 10.000 $PUNK will be made available to claim. 

An example: Say that you own 5 Punk NFTs and that the vesting period is 36 months. Than 50.000 $PUNK will be locked-up in your punks. 
36 months is about 1080 days. This means that you will be able to claim about 42 $PUNK every day over a period of 1080 days (50.000/1080)

## Trading during vesting
10.000 $PUNK is locked-up in every Punk NFT. When you sell a Punk during the vesting period, the claim rights will also be included. This means that the remaining $PUNK tokens that are yet to be vested, will also be sold to the new owner.

The same is the case when you buy a Punk during the vesting period. You will also buy the the remaining $PUNK tokens that are yet to be vested.

An example: Say that the vesting period is 36 months and you buy a Punk 6 months after the vesting period has started. Then you will be able to claim the remainder of the $PUNK tokens that are yet to be vested. In this case that is 10.000 x (30/36) = 8.333,33 $PUNK 

## Unclaimed tokens and trading
If you have not claimed any $PUNK during the vesting period and you sell a Punk. The total claim will transfer to the new owner. It is important to claim vested $PUNK on a regular basis, especially if you are trading Punks.


## Contract
The contract vests $PUNK every block. That is every 5 seconds. 

## Prerequisites
The deployment of the contract requires the Punk token contract to be deployed as well as the Punk NFT contract.
The Punk token contract can be found here: https://github.com/xDaiPunks/PunkTokenContract
A flattened version of the NFT contract can be found here: https://github.com/xDaiPunks/xDaiPunksNFT

The contract addresses of the Punk token contract and the Punks NFT contract are needed for the deployment of the contract.

The deployment variables:
- @param _start: unix time of the start of $PUNK vesting
- @param _cliff: delayed start of $PUNK vesting in seconds
- @param _duration: timespan of $PUNK vesting in seconds
- @param _totalAvailable: total available supply of the $PUNK token
- @param _Punk: contract address of the $PUNK ERC20 contract
- @param _Punks: interface of the Punks NFT contract

Note: if you are using remix and ganache you will need to fund the contract before the claims can be executed
Funding is 100.000.000

## Truffle
The vesting contract has been created using Truffle and OpenZeppelin 

### Deploying the token on a local environment
Install truffle and ganache-cli globally:
```sh
npm i truffle -g && npm i ganache-cli -g
```

Install dependencies

```sh
npm i 
```

Run truffle commands for example

```sh
ganche-cli

truffle build

truffle deploy
```


## Remix
To interact with this contract using Remix IDE (https://remix.ethereum.org/) using your local file system, you can install the remixd package.

```sh
npm install -g @remix-project/remixd
```

After install you can start remixd by issuing the followinng command:

```sh
remixd -s ~/YOUR-CONTRACT-DIRECTORY --remix-ide https://remix.ethereum.org/

```
Then in the Remix IDE choose 'localhost' as workspace and connect. You can also use your local ganache instance with Remix IDE. To do so, select 'Web3 Provider' for the environment. Make sure to have ganache-cli running 



