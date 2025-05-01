// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";

contract ClaimAirdrop is Script {
    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMOUNT = 25 * 1e18;
    bytes32 proofOne = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] proof = [proofOne, proofTwo];
    bytes private SIGNATURE = hex"";

    error __Interaction__ClaimAirdrop__InvalidSignatureLength();

    function claimAirdrop(address airdrop) public {
        vm.startBroadcast();
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, proof, v, r, s);
    }

    function splitSignature(bytes memory signature) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (signature.length != 65) {
            revert __Interaction__ClaimAirdrop__InvalidSignatureLength();
        }
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 32))
            v := byte(0, mload(add(signature, 96)))
        }
    }

    function run() external {
        address mostRecentlyDepoyed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDepoyed);
    }
}
