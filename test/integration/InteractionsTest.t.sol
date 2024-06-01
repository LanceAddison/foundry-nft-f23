// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {MintBasicNft} from "../../script/Interactions.s.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract InteractionsTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;

    address public USER = makeAddr("user");

    string public constant SHIB_URI = "https://ipfs.io/ipfs/QmVf8HEHtpznpNSyquAz8VSFDVHdS2gNLVPKYFhn6QPCxz?filename=SHIB.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCount();
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(basicNft.getTokenCount() == startingTokenCount + 1);
    }

    function testScriptMintUriIsCorrect() public {
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(SHIB_URI)));
    }
}