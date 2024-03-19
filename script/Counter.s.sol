// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract CounterScript is Script {
    function run() external {
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);

        // Defina o endereço do proprietário inicial aqui ou passe como argumento
        address initialOwner = msg.sender; 

        Counter counter = new Counter(initialOwner);

        vm.stopBroadcast();
    }
}
