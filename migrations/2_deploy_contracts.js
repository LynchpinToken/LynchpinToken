var LynchpinToken = artifacts.require("./LynchpinToken.sol");

module.exports = function(deployer) {
  deployer.deploy(LynchpinToken);
};
