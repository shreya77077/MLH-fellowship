//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./Token.sol";

contract TokenBank {
   
   MyToken public token;

   mapping(address => uint256) public balance;
   //mapping(address => uint256) public deadline;   // mapping user's address to deadline
    mapping (address => uint256) public deadline;

   constructor(address tokenAddress) {  
      token = MyToken(tokenAddress);      
   }


   function deposit(uint256 amount, uint256 deadlineInSeconds)public{
       require(token.transferFrom(msg.sender,address(this),amount),"Transfer failed");

       deadline[msg.sender]= block.timestamp + deadlineInSeconds;
       balance[msg.sender] +=amount;
   }
    

  
   function withdraw(uint256 amount) public {
    //require(block.timestamp < block.timestamp + deadline[msg.sender], "Deadline passed, no withdraw"); 
    require(block.timestamp < deadline[msg.sender], "Deadline passed, no withdraw"); 
    require(balance[msg.sender] >= amount, "Not enough balance");
    require(token.transfer( msg.sender,amount),"Transfer failed");
        
    balance[msg.sender] -= amount;
    }

}
