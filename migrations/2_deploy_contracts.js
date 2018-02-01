var MTSmartContract = artifacts.require("./MTSmartContract.sol");

module.exports = function(deployer) {
  deployer.deploy(MTSmartContract);
};
