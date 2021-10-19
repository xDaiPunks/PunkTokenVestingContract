const Punk = artifacts.require('Punk');

module.exports = function (deployer) {
  deployer.deploy(Punk, { gas: 5000000 });
};
