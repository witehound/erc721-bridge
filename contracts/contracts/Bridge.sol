// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bridge is ReentrancyGuard, Ownable, IERC721Receiver {
    uint256 costNative = 1 ether;
    uint256 costCustom = 0.000075 ether;

    struct Custody {
        uint256 tokenId;
        address holder;
    }

    mapping(uint25 => Custody) public holdCustudy;
}
