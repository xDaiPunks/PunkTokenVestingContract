const Vesting = artifacts.require('Vesting');

const start = 1634141102;
const cliff = 0;
const duration = 600;
const totalAvailable = 100000000000000000000000000;
const PunkContractAddress = '0xDB2a4Df88a3a5a3Ca1aDe9F3303Bb4fC98DefE35';
const PunksContractAddress = '0xEFb049408E3764951bFC7a64EeD02F532569d69A';

module.exports = function (deployer) {
  deployer.deploy(
    Vesting,
    start,
    cliff,
    duration,
    totalAvailable,
    PunkContractAddress,
    PunksContractAddress,
    { gas: 5000000 }
  );
};
