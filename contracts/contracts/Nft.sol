// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//5 hours working rembrandt

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is Ownable, ERC721Enumerable {
    using Strings for uint256;
    string public baseUri;
    string public baseExtension = ".json";
    uint256 public maxSupply = 1000;
    bool public paused = false;

    constructor() ERC721("Test Bridge", "BDG") {}
}
