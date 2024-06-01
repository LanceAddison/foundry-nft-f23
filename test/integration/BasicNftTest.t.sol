// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    address public USER = makeAddr("user");
    address public USER2 = makeAddr("user2");
    string public constant SHIB_URI = "https://ipfs.io/ipfs/QmVf8HEHtpznpNSyquAz8VSFDVHdS2gNLVPKYFhn6QPCxz?filename=SHIB_URI.json";

    uint256 public tokenId = 0;

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();

        vm.deal(USER, 1 ether);
        vm.deal(USER2, 1 ether);
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();

        // assert(expectedName == actualName);
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();

        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    function testTokenUriIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(SHIB_URI);

        string memory expectedUri = SHIB_URI;
        string memory actualUri = basicNft.tokenURI(tokenId);

        assert(keccak256(abi.encodePacked(expectedUri)) == keccak256(abi.encodePacked(actualUri)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(SHIB_URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(SHIB_URI)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    function testCanTransferNft() public {
        vm.prank(USER);
        basicNft.mintNft(SHIB_URI);

        vm.prank(USER);
        basicNft.safeTransferFrom(USER, USER2, tokenId);

        assert(basicNft.balanceOf(USER) == 0);
        assert(basicNft.ownerOf(0) == USER2);
    }
}