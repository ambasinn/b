// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.13;

import "../types/Guarantee.sol";

abstract contract GuaranteeTester {
    function read() public virtual view returns (Guarantee memory);

    function store(Guarantee memory newGuarantee) public virtual;

    function from(Order memory order, Fixed6 price, UFixed6 referralFee, bool chargeSettlementFee, bool chargeTradeFee) external {
        Guarantee memory newGuarantee = GuaranteeLib.from(order, price, referralFee, chargeSettlementFee, chargeTradeFee);
        store(newGuarantee);
    }
}

contract GuaranteeGlobalTester is GuaranteeTester {
    GuaranteeStorageGlobal public guarantee;

    function read() public view override returns (Guarantee memory) {
        return guarantee.read();
    }

    function store(Guarantee memory newGuarantee) public override {
        guarantee.store(newGuarantee);
    }
}

contract GuaranteeLocalTester is GuaranteeTester {
    GuaranteeStorageLocal public guarantee;

    function read() public view override returns (Guarantee memory) {
        return guarantee.read();
    }

    function store(Guarantee memory newGuarantee) public override {
        guarantee.store(newGuarantee);
    }
}
