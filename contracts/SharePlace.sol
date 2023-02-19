pragma solidity ^0.8.0;

import "./User.sol";

contract SharePlace is User {
    address owner;
    address txFeesAddress;
    uint txFeePercent;

    constructor(address _txFeesAddress, uint _txFeePercent) {
        owner = msg.sender;
        txFeesAddress = _txFeesAddress;
        txFeePercent = _txFeePercent;
    }

    event AskEth(
        address userAddress,
        address funderAddress,
        uint amountAsked,
        uint timestamp,
        uint blockNumber
    );

    modifier enableToAsk(address funderAddress, uint amount) {
        bool notInList = false;
        require(funderAddress != address(0), "unknow address");
        require(amount > 0, "cannot ask with negative value");

        if (_askedEthList[msg.sender].length != 0) {
            for (uint i; i < _askedEthList[msg.sender].length; i++) {
                require(
                    msg.sender != _askedEthList[msg.sender][i],
                    "cannot ask multiple times"
                );
            }
        }
        _;
    }

    // computes the transaction fee
    function txFees(uint amount) private view returns (uint) {
        return (amount * txFeePercent) / 100;
    }

    function showList() public view returns (address[] memory) {
        return _askedEthList[msg.sender];
    }

    // Ask borrowed eth to another user (can only ask one time)
    function askEth(
        address funderAddress,
        uint amount
    ) public enableToAsk(funderAddress, amount) {
        _asked[funderAddress][msg.sender].userAskedAddress = msg.sender;
        _asked[funderAddress][msg.sender].ethToBorrow = amount;
        _asked[funderAddress][msg.sender].status = Status.InProgress;

        _askedEthList[funderAddress].push(msg.sender);
    }
}
