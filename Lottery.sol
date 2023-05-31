pragma solidity >=0.5.0 < 0.9.0;
//Lottery contract that randomly selects a particiapants from the existing particiapnts and sends the amount(ETH) to the winner(selected participant)
//manager is the one who can deploy this contract, and the address of the manager will be strored in msg.sender.
contract Lottery{
    address public manager;//storing the manager in address data type
    address payable[] public participants;//storing participants in an array of payable

    constructor() public
    {
        manager=msg.sender;//msg.sender represents the account from which the transaction is sent which is in this case the manager.
    }
    receive() external payable{
        require(msg.value== 1 ether);//minimum of 1 ether is required to be sent to make a transaction
        participants.push(payable(msg.sender));

    }
    function GetBalance() public view returns(uint){
        require(msg.sender==manager);//this will check whether the address of the manager is correct (as chosen above), if yes then it will continue but if not it will stop. 

        return address(this).balance;
    }
    function random() public view returns(uint256){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));

    }
    function selectwinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        address payable winner;
        uint index= r % participants.length;
        winner = participants[index];
        winner.transfer(GetBalance());
        participants= new address payable[](0);

    }
    
}
