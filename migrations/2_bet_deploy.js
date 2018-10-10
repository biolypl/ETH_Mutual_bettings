var Bet = artifacts.require("./Bet.sol");

module.exports = function(deployer) {
    deployer.deploy(Bet, "real", 10, 1577836800,1577836810, ["0x10","0x20"]);
};
