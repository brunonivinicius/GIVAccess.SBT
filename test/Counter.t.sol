// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GIVSBT} from "../src/GIVSBT.sol";

contract GivSbtTest is Test {
    GIVSBT givsbt;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        givsbt = new GIVSBT(owner);
    }

    function testSafeMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        givsbt.safeMint(user, uri);
        vm.stopPrank();

        assertEq(givsbt.balanceOf(user), 1, "Balance should be 1 after minting");
        assertEq(givsbt.ownerOf(0), user, "User should own the minted token");
        assertEq(givsbt.tokenURI(0), uri, "Token URI should match the provided URI");
    }

    function testLockingAfterMint() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        givsbt.safeMint(user, uri);
        vm.stopPrank();

        bool isLocked = givsbt.locked(0);
        assertTrue(isLocked, "Token should be locked after minting");
    }

    function testTransferNotAllowed() public {
        vm.startPrank(owner);
        string memory uri = "https://example.com/token/1";
        givsbt.safeMint(user, uri);
        vm.stopPrank();

        vm.expectRevert("Transfer not allowed");
        givsbt.safeTransferFrom(user, owner, 0);
    }
}
