// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol"; // AccessControl contract
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract DAO is AccessControl, ReentrancyGuard {
    //imutable(cannot change) hash is linked to the role
    bytes32 private imutable CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");
    bytes32 private imutable STACKHOLDER_ROLE = keccak256("STACKHOLDER_ROLE");

    struct Proposal {
        uint id;
        address proposer;
        string description;
        uint votes;
        uint end;
        bool    
    }

    uint public proposalCount;
    mapping(uint => Proposal) public proposals;

    constructor() {
        _setupRole(DEFAULT_STACKHOLDER_ROLE, msg.sender);
        _setupRole(STACKHOLDER_ROLE, msg.sender);
        _setupRole(CONTRIBUTOR_ROLE, msg.sender);
    }

    function addProposal(string memory _description) external {
        require(hasRole(STACKHOLDER_ROLE, msg.sender), "DAO: must have member role to add proposal");
        proposals[proposalCount] = Proposal(proposalCount, msg.sender, _description, 0, block.timestamp + 1 days, false);
        proposalCount++;
    }

    function vote(uint _id) external {
        require(hasRole(STACKHOLDER_ROLE, msg.sender), "DAO: must have stackholder role to vote");
        require(proposals[_id].end > block.timestamp, "DAO: voting period has ended");
        require(!proposals[_id].voters[msg.sender], "DAO: voter has already voted");
        proposals[_id].votes++;
        proposals[_id].voters[msg.sender] = true;
    }

    function executeProposal(uint _id) external nonReentrant {
        require(hasRole(CONTRIBUTOR_ROLE, msg.sender), "DAO: must have contributor role to execute proposal");
        require(proposals[_id].end < block.timestamp, "DAO: voting period has not ended");
        require(!proposals[_id].executed, "DAO: proposal has already been executed");
        if(proposals[_id].votes > proposalCount / 2) {
            proposals[_id].executed = true;
           
        }
    }
}