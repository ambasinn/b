// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.24;

import "@equilibria/root/attribute/Ownable.sol";
import "@equilibria/root/attribute/Factory.sol";
import "@equilibria/root/attribute/Pausable.sol";
import "./interfaces/IVaultFactory.sol";
import { VaultParameter } from "./types/VaultParameter.sol";

/// @title VaultFactory
/// @notice Manages creating new markets and global protocol parameters.
contract VaultFactory is IVaultFactory, Factory {
    UFixed6 public immutable initialAmount;

    /// @dev The market factory
    IMarketFactory public immutable marketFactory;

    /// @dev Mapping of allowed operators for each account
    mapping(address => mapping(address => bool)) public operators;

    /// @notice Constructs the contract
    /// @param marketFactory_ The market factory
    /// @param implementation_ The initial vault implementation contract
    /// @param initialAmount_ The initial amount of the underlying asset to deposit and lock
    constructor(
        IMarketFactory marketFactory_,
        address implementation_,
        UFixed6 initialAmount_
    ) Factory(implementation_) {
        marketFactory = marketFactory_;
        initialAmount = initialAmount_;
    }

    /// @notice Initializes the contract state
    function initialize() external initializer(1) {
        __Factory__initialize();
    }

    /// @notice Creates a new vault
    /// @param asset The underlying asset of the vault
    /// @param initialMarket The initial market of the vault
    /// @param name The name of the vault
    /// @return newVault The new vault
    function create(
        Token18 asset,
        IMarket initialMarket,
        string calldata name
    ) external onlyOwner returns (IVault newVault) {
        // create vault
        newVault = IVault(address(
            _create(abi.encodeCall(IVault.initialize, (asset, initialMarket, initialAmount, name)))));

        // deposit and lock initial amount of the underlying asset to prevent inflation attacks
        asset.pull(msg.sender, UFixed18Lib.from(initialAmount));
        asset.approve(address(newVault), UFixed18Lib.from(initialAmount));
        newVault.update(address(this), initialAmount, UFixed6Lib.ZERO, UFixed6Lib.ZERO);

        emit VaultCreated(newVault, asset, initialMarket);
    }

    /// @notice Updates the status of an operator for the caller
    /// @param operator The operator to update
    /// @param newEnabled The new status of the operator
    function updateOperator(address operator, bool newEnabled) external {
        operators[msg.sender][operator] = newEnabled;
        emit OperatorUpdated(msg.sender, operator, newEnabled);
    }
}
