// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserProfile.sol";

contract UserFactory {

    address[] public createdProfiles;
    mapping(string=>address) public userProfile;
    mapping(address=>address) public creatorContract;
    address public admin;
    uint public suscriptionFee; //20% of 100
    uint public amountRecaudedFees;

    constructor(){
        admin = msg.sender;
        suscriptionFee = 20;
    }

    function createProfile(string memory _tokenName,string memory _tokenSymbol,
    string memory _name,string memory _description,uint _bronzePrice,uint _silverPrice,uint _goldPrice) public
    {
        address profileAddress = userProfile[_name];
        require(creatorContract[msg.sender] == address(0),"duplicate account");
        require(profileAddress == address(0));
        UserProfile newUser = new UserProfile(_tokenName,_tokenSymbol,msg.sender,_name,_description, _bronzePrice, _silverPrice, _goldPrice,suscriptionFee);
        address addr = address(newUser);
        //add the created profile to store data variables
        createdProfiles.push(addr);
        userProfile[_name] = addr;
        creatorContract[msg.sender] = addr;
    }
    function isSignedUp(address _creatorAddress) external view returns(bool){
        if(creatorContract[_creatorAddress] == address(0)) return false;
        return true;
    }

    function recaudeFees()external payable{
        amountRecaudedFees += msg.value;
    }

    function withdrawFees(address payable _to)public{
        require(msg.sender==admin);
        _to.transfer(amountRecaudedFees);
        amountRecaudedFees = 0;
    }


    function getCreatorContractAddress(address _creatorAddress) external view returns(address){
        return creatorContract[_creatorAddress];
        
    }

    
    function getAllCreators() public view returns(address[] memory){
        return createdProfiles;
    }

    
}