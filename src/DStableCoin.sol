// SPDX-License-Identifier: MIT

// This is considered an Exogenous, Decentralized, Anchored (pegged), Crypto Collateralized low volitility coin

pragma solidity 0.8.20;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
 * @title DStableCoin
 * @author Kris
 * Collateral: Exogenous
 * Minting (Stability Mechanism): Decentralized (Algorithmic)
 * Value (Relative Stability): Anchored (Pegged to USD)
 * Collateral Type: Crypto
 *
 * This is the contract meant to be owned by DSCEngine. It is a ERC20 token that can be minted and burned by the DSCEngine smart contract.
 */
// we are using ERC20Burnable because it has burn function to maintain the pegged price.

contract DStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__AmountMustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__NotZeroAddress();

    constructor() ERC20("DStableCoin", "DSC") {}

    function burn(uint256 _amount) public override onlyOwner {
        /*
        the burn function is a critical component that allows the removal of a certain number of tokens from circulation. 
        This process is essential for managing the supply of tokens within the ecosystem, 
        often used to increase the value of the remaining tokens by reducing the total supply.
        */
        uint256 balance = balanceOf(msg.sender);

        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }

        /* super. keyword allows to inherit  from OpenZeppelin's contract and call its methods*/
        super.burn(_amount);
    }

    /*
    The mint function is used to create new tokens and add them to the circulating supply. 
    This action increases the total number of tokens available in the market, 
    which can lead to a decrease in the token's price if the demand remains constant
    */

    function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
        // when return mint, we have to return a boolean
        if (_to == address(0)) {
            revert DecentralizedStableCoin__NotZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__AmountMustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
