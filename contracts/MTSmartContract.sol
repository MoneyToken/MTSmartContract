//


import "./Multiownable.sol";

pragma solidity ^0.4.18;


contract MTSmartContract is Multiownable {
    
    User[] users;
    Credit[] credits;
    
    struct User {
        address wallet;
    }
    
    struct Credit {
        uint id;
        string name;
        address wallet;
        bool approved;
        address owner;
        mapping (address => uint) pendingWithdrawals; // withdrawal pattern
    }


    modifier membersOnly {
        for(uint i = 0; i < users.length; i++) {
            if(users[i].wallet == msg.sender) {
                _;
                break;
            }
        }
    }

    modifier newcomers {
        for(uint i = 0; i < users.length; i++) {
            if(users[i].wallet == msg.sender) {
                return;
            }
        }
        _;
    }

    modifier ownsCredit {
        for(uint i = 0; i < credits.length; i++) {
            if(credits[i].owner == msg.sender) {
                _;
                break;
            }
        }
    }
    
    function MTSmartContract() public {
        joinIn();
    }
    
    function joinIn() public newcomers {
        users.push( User({wallet: msg.sender}) );
    }


    //withdrawal credit
    function withdrawLoans(uint credit_id) public ownsCredit {
        for(uint i = 0; i < credits.length; i++) {
            if(credits[i].id == credit_id) {
                uint amount = credits[i].pendingWithdrawals[msg.sender];
                credits[i].pendingWithdrawals[msg.sender] = 0;
                break;
            }
        }
    }
    
    /**
     * @return uint credit unique ID
     * */
    function addCredit(string name, address wallet) public onlyAnyOwner returns(uint) {
        uint id = credits.length+1;
        credits.push(Credit({
            id: id,
            name: name,
            wallet: wallet,
            owner: msg.sender,
            approved: false
        }));
        
        return id;
    }
    
    /**
     * Only owners can do this
     * */
    function approveCredit(uint id) public onlyManyOwners returns(bool) {
        for(uint i = 0; i < credits.length; i++) {
            if(credits[i].id == id) {
                credits[i].approved = true;
                return true;
            }
        }
        return false;
    }
}
