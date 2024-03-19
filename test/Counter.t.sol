// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        counter = new Counter(owner);
    }

    function testSafeMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        counter.safeMint(user, uri);
        vm.stopPrank();

        assertEq(counter.balanceOf(user), 1, "Balance should be 1 after minting");
        assertEq(counter.ownerOf(0), user, "User should own the minted token");
        assertEq(counter.tokenURI(0), uri, "Token URI should match the provided URI");
    }

    function testLockingAfterMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        counter.safeMint(user, uri);
        vm.stopPrank();

        bool isLocked = counter.locked(0);
        assertTrue(isLocked, "Token should be locked after minting");
    }

    function testTransferNotAllowed() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        counter.safeMint(user, uri);
        vm.stopPrank();

        vm.expectRevert("Transfer not allowed");
        counter.safeTransferFrom(user, owner, 0);
    }
}
