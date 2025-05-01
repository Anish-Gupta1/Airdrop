// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ToraToken} from "../src/ToraToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 public s_merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 public s_amount = 4 * 25 * 1e18;

    function deployMerkleAirdrop() public returns (MerkleAirdrop, ToraToken) {
        vm.startBroadcast();
        ToraToken token = new ToraToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(token)));
        token.mint(token.owner(), s_amount);
        token.transfer(address(merkleAirdrop), s_amount);
        vm.stopBroadcast();
        return (merkleAirdrop, token);
    }

    function run() external returns (MerkleAirdrop, ToraToken) {
        return deployMerkleAirdrop();
    }
}
