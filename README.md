# Bitcoin Investment DAO Smart Contract

## Overview

The Bitcoin Investment DAO is a decentralized autonomous organization (DAO) implemented as a Clarity smart contract on the Stacks blockchain. It enables collective Bitcoin investment decisions through a democratic proposal and voting system. Members can stake STX tokens to participate in governance, create investment proposals, and vote on them.

## Features

- Token staking and unstaking mechanism
- Democratic proposal creation and voting system
- Configurable quorum threshold for proposal passing
- Automated proposal execution
- Member management system
- Transparent voting record keeping

## Contract Details

### Constants

- Minimum proposal amount: 1,000,000 uSTX
- Proposal duration: 144 blocks (~24 hours)
- Quorum threshold: 50% (500 basis points)
- Various error codes for different failure scenarios

### Core Functionality

#### Membership

1. **Staking (stake-tokens)**

   - Members stake STX tokens to gain voting power
   - Staked amount directly correlates to voting weight
   - Tokens are held in the contract during the staking period

2. **Unstaking (unstake-tokens)**
   - Members can withdraw their staked tokens
   - Requires sufficient balance
   - Updates total staking metrics

#### Proposal System

1. **Creation (create-proposal)**

   - Requires minimum stake to create proposals
   - Includes title (max 100 chars), description (max 500 chars)
   - Specifies amount and recipient for investment
   - Automatically sets voting period

2. **Voting (vote)**

   - One vote per member per proposal
   - Vote weight based on staked amount
   - Votes tracked as yes/no with amount
   - Voting restricted to active proposal period

3. **Execution (execute-proposal)**
   - Automated execution after voting period
   - Requires meeting quorum threshold
   - More yes votes than no votes needed
   - Transfers funds if approved
   - Updates proposal status

### Read-Only Functions

1. **get-member-info**

   - Returns member's staked amount
   - Shows last reward block
   - Displays claimed rewards

2. **get-proposal-info**

   - Returns full proposal details
   - Shows current voting status
   - Displays execution status

3. **get-vote-info**

   - Returns specific vote details
   - Shows voter's decision

4. **get-dao-info**
   - Returns global DAO metrics
   - Shows total staked amount
   - Displays proposal count

## Usage Examples

### Staking Tokens

```clarity
(contract-call? .bitcoin-investment stake-tokens u1000000)
```

### Creating a Proposal

```clarity
(contract-call? .bitcoin-investment create-proposal
    "Invest in Bitcoin Mining"
    "Proposal to allocate funds for mining equipment"
    u5000000
    'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Voting on a Proposal

```clarity
(contract-call? .bitcoin-investment vote u1 true)
```

### Executing a Proposal

```clarity
(contract-call? .bitcoin-investment execute-proposal u1)
```

## Security Considerations

1. **Access Control**

   - Only DAO members can vote
   - Proposal creation requires minimum stake
   - Owner privileges limited to initialization

2. **Input Validation**

   - String length restrictions
   - Amount validation
   - Principal address validation

3. **Timing Controls**
   - Proposal duration enforcement
   - Prevention of duplicate votes
   - Status-based execution controls

## Error Codes

- `ERR-NOT-AUTHORIZED (u100)`: Unauthorized access attempt
- `ERR-INVALID-AMOUNT (u101)`: Invalid token amount
- `ERR-PROPOSAL-NOT-FOUND (u102)`: Proposal ID doesn't exist
- `ERR-ALREADY-VOTED (u103)`: Duplicate vote attempt
- `ERR-PROPOSAL-EXPIRED (u104)`: Voting period ended
- `ERR-INSUFFICIENT-BALANCE (u105)`: Insufficient staked tokens
- `ERR-PROPOSAL-NOT-ACTIVE (u106)`: Proposal not in active state
- `ERR-INVALID-STATUS (u107)`: Invalid proposal status
- `ERR-INVALID-OWNER (u108)`: Invalid owner address
- `ERR-INVALID-TITLE (u109)`: Invalid proposal title
- `ERR-INVALID-DESCRIPTION (u110)`: Invalid proposal description
- `ERR-INVALID-RECIPIENT (u111)`: Invalid recipient address

## Development and Testing

To interact with the contract using Clarinet:

1. Start the Clarinet console:

```bash
clarinet console
```

2. Deploy the contract and initialize with test accounts
3. Use the provided test wallet addresses for development
4. Test all functions with various scenarios

## Limitations and Future Improvements

1. **Current Limitations**

   - Fixed voting period
   - Simple majority voting system
   - Basic reward mechanism

2. **Potential Enhancements**
   - Dynamic voting periods
   - Quadratic voting implementation
   - Multiple proposal types
   - Enhanced reward distribution
   - Proposal delegation system
   - Emergency pause mechanism

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
