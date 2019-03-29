pragma solidity ^0.5.0; //tells solidity which version of a compiler to use 

import "openzeppelin-solidity/blob/v2.0.0/contracts/token/ERC721/ERC721.sol"

contract Vineyard {
  //this is a struct 
  struct Wine {
    uint age; 
    string type;
    uint score; 
   // address owner; redundant because we already know who the owner is   

  }

// the following are global variables: 
address vineyard_deployer; 
uint max_number_of_bottles; 
uint total_wine_bottles; 
mapping(uint => address) vineyard_owners;
mapping(uint => Wine) wine_list; 

constructor(){
  contract_deployer = msg.sender; //the person starting the trade
  //constructor determines what we need to make sure of 
  //block.number is the ??
  //msg.value ??
  max_number_of_bottles = 30; 
  total_wine_bottles = 0; 
}

function trade(address from, address to, uint wine_id) payable {
  require(from == vineyard_owners[wine_id]);
  require(to != address(0)); //read up on hash tables 
  vineyard_owners[wine_id] = to; 
  safeTransferFrom(from, to, wine_id); 
}

function makeWine(uint _age, string _type, uint _score) {
  //require(msg.sender == contract_deployer); 

  require(msg.value == 0.008 ether); 
  require(total_wine_bottles < max_number_of_bottles);
  require(_age < 10);
  require(_score < 90);
  total_wine_bottles = total_wine_bottles + 1; 

  Vineyard memory instance = Vineyard(_age, _type, _score); 
  wine_list[total_wine_bottles] = instance; 
  _mint(msg.sender, total_wine_bottles);
  vineyard_owners[total_wine_bottles] = msg.sender; 
}

function drink(address payable _givewine) public {
  require(msg.sender == contract_deployer); 
  _givewine.transfer(address(this).balance); 
}

}

