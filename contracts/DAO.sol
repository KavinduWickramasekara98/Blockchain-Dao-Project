// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/AccessControl.sol"; // AccessControl contract
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract DAO is AccessControl, ReentrancyGuard {
    //imutable(cannot change) hash is linked to the role
    bytes32 private imutable CONTRIBUTOR_ROLE = keccak256("CONTRIBUTOR_ROLE");
    bytes32 private imutable STACKHOLDER_ROLE = keccak256("STACKHOLDER_ROLE");
uint256 private imutable MINIMUM_CONTRIBUTION = 1 ether;
unint32 private imutable VOTING_PERIOD = 2 minutes;
uint32 totalProposalCount;
uint256 public daoBalance;
    struct ProposalStruct {
        uint256 id;
        uint256 amount;
        uint256 dutation;
        uint256 upvotes;
        uint256 downvotes;
        string title;
        string description;
        bool passed;
        bool paid;
        address payable beneficiary;
        address proposer;
        address executor;    
    }

    struct votedStruct {
        address voter;
        uint256 timestamp;
        bool chosen;
    }   
    event Action(
        address indexed initiator,
        byetes32 role,
        string message,
        address indexed beneficiary,
        uint256 amount
    );

    mapping(uint => ProposalStruct) public raisedProposals;
    mapping(address=>uint256[]) private stackholderVotes;
    mapping (uint256 => votedStruct[]) private votedOn;
    mapping(address=>uint256) private contributors;
    mapping(address=>uint256) private stackholders; 
//hasRole from AccessControl contract
    modifier stackholderOnly(string memory message) {
        require(hasRole(STACKHOLDER_ROLE,msg.sender),message);
        _;          
        
    }
//hasRole from AccessControl contract
    modifier contributorOnly(string memory message) {
        require(hasRole(CONTRIBUTOR_ROLE,msg.sender),message);
        _;          
        
    }
function createProposal(
    string memory _title,
    string memory _description,
    address beneficiary,
    uint256 _amount
)external stackholderOnly("stackholders only"){
    {

        uint32 proposalId = totalProposalCount++;
        ProposalStruct storage proposal = raisedProposals[proposalId];
        proposal.idproposalId;
        proposal.amount = _amount;
        proposal.duration = block.timestamp + VOTING_PERIOD;
        proposal.title = _title;
        proposal.description = _description;
        proposal.beneficiary = payable(beneficiary);
        proposal.proposer =payable(msg.sender);

    }
    emit Action(
        msg.sender,
        STACKHOLDER_ROLE,
        "created proposal",
        beneficiary,
        _amount
    )
    function handleVoting(ProposalStruct storage proposal) private {
       if(
        proposal.passed ||
        proposal.duration <= block.timestamp
       ){
        proposal.passed = true;
        revert("proposal duration has been expired");
       }
       uint256[] memory tempVotes = stackholderVotes[msg.sender];
       for(uint votes = 0; i < votes.tempVotes; votes++){
           if(proposal.id == tempVotes[votes]){
               revert("you have already voted on this proposal");
           }
       }
    }
}