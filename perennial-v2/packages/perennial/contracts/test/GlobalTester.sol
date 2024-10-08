// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "../types/Global.sol";

contract GlobalTester {
    GlobalStorage public global;

    function read() external view returns (Global memory) {
        return global.read();
    }

    function store(Global memory newGlobal) external {
        return global.store(newGlobal);
    }

    function update(
        uint256 newLatestId,
        VersionAccumulationResponse memory accumulation,
        MarketParameter memory marketParameter,
        OracleReceipt memory oracleReceipt
    ) external {
        Global memory newGlobal = global.read();
        newGlobal.update(newLatestId, accumulation, marketParameter, oracleReceipt);
        global.store(newGlobal);
    }
}
