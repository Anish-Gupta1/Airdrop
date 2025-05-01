// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {ToraToken} from "../src/ToraToken.sol";

import {ZkSyncChainChecker} from "lib/foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is ZkSyncChainChecker, Test {
    MerkleAirdrop private merkleAirdrop;
    ToraToken private token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    uint256 userPrivkey;

    uint256 constant AMOUNT = 25 * 1e18;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];

    function setUp() public {
        if (!isZkSyncChain()) {
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (merkleAirdrop, token) = deployer.deployMerkleAirdrop();
        } else {
            token = new ToraToken();
            merkleAirdrop = new MerkleAirdrop(ROOT, token);
            token.mint(address(merkleAirdrop), AMOUNT * 4);
            console.log("User address: ", user);
        }
        (user, userPrivkey) = makeAddrAndKey("user");
    }

    function testUserCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);

        vm.prank(user);

        merkleAirdrop.claim(user, AMOUNT, PROOF);

        uint256 endingBalance = token.balanceOf(user);

        assertEq(endingBalance - startingBalance, AMOUNT);
    }
}
