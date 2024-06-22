# Donations Contract

## About

This contract is a fundraiser, in which users can send Eth and then the owner can withdraw the funds

## Functions

1. Users send ETH which is converted to dollars and if users don't send ETH above 5 dollars, the transaction will not go through
2. ETH is converted to dollars with a Price Convertor
3. The owner of the contract can withdraw the funds at any time
4. THe funders and the amount they send are stored in an array

## Smart Contracts Overview

- **Donations**: Allows users to fund with ETH, which is automatically converted to its USD equivalent. It includes functions for funding, withdrawing, and querying contributions.

- **DeployDonations**: Script to deploy the FundMe contract with settings appropriate for the active network.

- **FundDonations**: Script that allows to programatically fund the FundMe contract by sending ETH directly.

- **WithdrawDonations**: Script for programatically withdrawing all funds from the FundMe contract

- **Interactions**: Contains ```FundDonations``` and ```WithdrawDonations```

- **HelperConfig**: Allows the deploying of the contracts in differents Environements and Networks.

## Prerequisites

To interact with the FundMe contract or deploy it yourself, you'll need:
- [Foundry](https://book.getfoundry.sh/getting-started/installation.html) for smart contract development and testing
- An Ethereum wallet like [Metamask](https://metamask.io/)

## Clone Repository

```
git clone https://github.com/DontMind-me/foundry-donations
cd foundry-donations
forge build
```

## Usage 

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(add_rpc_url) --private-key $(add_your_private_key) --broadcast --verify --etherscan-api-key $(add_etherscan_api_key) -vvvv
```
------------------------------------
## THANK YOU FOR VISITING MY PROJECT!!
