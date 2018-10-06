# ETH_Mutual_bettings

## Features
By deploying this contract you define an event with possible options to bet.  Example constructor:
```
{
	"string betName": "Club A vs Club B", // name of the bet
	"uint8 myFee": 10, // Your fee as a deployer
	"uint256 _closeTime": "1577836800", // Time when the contract will not accept more deposits
	"uint256 _solveTime": "1577836810", // Time when the contract would be able to resolve
	"bytes32[] _options": [ // Event options
		"0x1000000000000000000000000000000000000000000000000000000000000000",
		"0x2000000000000000000000000000000000000000000000000000000000000000"
	]
}
```
### By using this software you agree to [GNUv3 license](https://github.com/biolypl/ETH_Mutual_bettings/blob/master/LICENSE) 
