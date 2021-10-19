# Punk Vesting Contract
The Punk ($PNK) vesting contract uses a linear timespan to vest $PNK tokens. The vested $PNK tokens are tied to 
the xDaiPunk NFTs. The total vested supply is 100.000.000. That is 10k $PNK tokens per xDaiPunk.
The vesting period is currently set at 24 months but open for discussion. We would like to see a longer vesting period as this
incentivises the 'Punk HODL'. Furthermore, the longer the vesting period, the more attractive it will be to participate in the Intial Bond Curve Offering of the $PNK token.


## Prerequisites
The deployement of the contract requires the Punk token contract to be deployed as well as the Punk NFT contract.
The Punk tokenn contract can be found here: https://github.com/xDaiPunks/PunkTokenContract
A flattened version of the NFT contract can be found here: https://github.com/xDaiPunks/xDaiPunksNFT

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



