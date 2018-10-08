pragma solidity ^0.4.0;
//import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/master/contracts/math/SafeMath.sol";

import "./node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
// Contract for mutual bettings
contract Bet {
    using SafeMath for uint;
    // Structure for one of option in bet
    struct Option {
        bytes32 name;
        uint pool;
    }
    // One user = one address = one bet
    struct User {
        bool set; // Did already bet?
        uint amount; // Bet amount
        uint select; // Chosen option id
    }

    string public name; // Name for the bet event
    uint public rewardPool; // Sum of all rewards in game
    uint private fee; // Fee for contract deployer
    address private owner; // deployer
    uint private closeTime; // Time to stop accept new bets in UNIX
    uint private solveTime; // Minimal time to resolve bet in UNIX
    Option[] public options; // Options array
    address[] public betersAccts; // Array of success beters

    constructor (string betName, uint _fee, uint _closeTime, uint _solveTime, bytes32[] _options) public {//string[] is for experimental ABI, so use bytes
        require(_solveTime > _closeTime, "Close time can't be larger than solve");
        owner = msg.sender;
        name = betName;

        if (_fee <= 99) {
            fee = _fee;
        }
        closeTime = _closeTime;
        solveTime = _solveTime;
        rewardPool = 0;

        for (uint i = 0; i < _options.length; i++) {
            options.push(Option({
                name : _options[i],
                pool : 0
                })
            );
        }


    }
    // Map address to users
    mapping(address => User) public beters;

    // Method to deposit a bet
    function deposit(uint _option) public payable {
        require(_option < options.length, "No such option!"); // Option ID has to exist
        if (block.timestamp < closeTime) {
            rewardPool = rewardPool.add(msg.value);

            options[_option].pool = options[_option].pool.add(msg.value);

            User storage sender = beters[msg.sender];
            require(!sender.set, "Already did a bet.");
            sender.set = true;
            sender.select = _option;
            sender.amount = msg.value;
            betersAccts.push(msg.sender) -1; // https://ethereum.stackexchange.com/questions/40312/what-is-the-return-of-array-push-in-solidity

        }
    }
    // Method to choose the winning option and share the rewards
    function withdraw(uint _winningOption) public payable {
        require(owner==msg.sender, "The bet can be solved only by owner");
        if (block.timestamp > solveTime) {

            if(fee!=0){
                uint creatorFee = (rewardPool.mul(fee)).div(100);
                rewardPool = rewardPool.sub(creatorFee);
            }

            for(uint i=0; i< betersAccts.length; i++){
                if(beters[betersAccts[i]].select == _winningOption){
                    uint reward = ((beters[betersAccts[i]].amount.mul(100).div(options[_winningOption].pool)).mul(rewardPool)).div(100);
                    betersAccts[i].transfer(reward);
                    // SEND THE REWARDS
                }
            }

            //DESTROY THE CONTRACT, SEND REST TO CREATOR
            selfdestruct(owner);
        }

    }

    function getCourse(uint _option) public view returns(uint) {
        require(_option < options.length, "No such option!"); // Option ID has to exist
        return (rewardPool.mul(100).div(options[_option].pool));
    }
}
