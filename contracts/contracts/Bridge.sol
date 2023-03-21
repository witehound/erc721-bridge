// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bridge is ReentrancyGuard, Ownable, IERC721Receiver {
    uint256 costNative = 1 ether;
    uint256 costCustom = 0.000075 ether;

    ERC721Enumerable nft;
    IERC20 payToken;

    struct Custody {
        uint256 tokenId;
        address holder;
    }

    mapping(uint256 => Custody) public holderCustudy;

    event NftCustody(uint256 indexed tokenId, address holder);

    constructor(ERC721Enumerable _nft, IERC20 _payToken) {
        nft = _nft;
        payToken = _payToken;
    }

    function retainNFTC(uint256 _tokenId) public payable nonReentrant {
        require(
            msg.value >= costCustom,
            "Not enough balance to complete transaction"
        );
        require(nft.ownerOf(_tokenId) == msg.sender, "Nft is not yours");
        require(holderCustudy[_tokenId].tokenId == 0, "Nft already stored");
        require(payToken.transferFrom(msg.sender, address(this), costCustom));

        holderCustudy[_tokenId] = Custody(_tokenId, msg.sender);

        nft.transferFrom(msg.sender, address(this), _tokenId);

        emit NftCustody(_tokenId, msg.sender);
    }

    function retainNFTN(uint256 _tokenId) public payable nonReentrant {
        require(
            msg.value >= costNative,
            "Not enough balance to complete transaction"
        );
        require(nft.ownerOf(_tokenId) == msg.sender, "Nft is not yours");
        require(holderCustudy[_tokenId].tokenId == 0, "Nft already stored");
        payable(address(this)).transfer(costNative);

        holderCustudy[_tokenId] = Custody(_tokenId, msg.sender);

        nft.transferFrom(msg.sender, address(this), _tokenId);

        emit NftCustody(_tokenId, msg.sender);
    }

    function updateOwner(
        uint256 _tokenId,
        address _newOwner
    ) public nonReentrant onlyOwner {
        holderCustudy[_tokenId] = Custody(_tokenId, _newOwner);
        emit NftCustody(_tokenId, _newOwner);
    }

    function releaseNft(
        uint256 _tokenId,
        address wallet
    ) public nonReentrant onlyOwner {
        nft.transferFrom(msg.sender, wallet, _tokenId);
    }

    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure override returns (bytes32) {
        require(from == address(0x0), "Cannot Recieve Nfts Directly");
        return IERC721Receiver.onERC721Received.selector;
    }
}
