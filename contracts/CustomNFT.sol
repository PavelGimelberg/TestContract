// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract CustomNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, IERC2981 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Royalty fee percentage, with a value of 10000 representing 100%
    uint256 private constant ROYALTY_FEE_BASE = 10000;

    // Mapping of token ID to royalty fee percentage
    mapping(uint256 => uint256) private _royaltyFees;

    // Mapping of token ID to the original creator
    mapping(uint256 => address) private _originalCreators;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

 function _baseURI() internal view override returns (string memory) {
    return "";
}


	function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
  	  super._beforeTokenTransfer(from, to, tokenId,1);
	}


    function safeMint(address to, string memory _tokenURI, uint256 royaltyFee) public onlyOwner {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        // Set original creator and royalty fee
        _originalCreators[tokenId] = to;
        _royaltyFees[tokenId] = royaltyFee;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId) || interfaceId == type(IERC2981).interfaceId;
    }

    // Implement royalty info function for ERC-2981 standard
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        uint256 royaltyFee = _royaltyFees[tokenId];
        receiver = _originalCreators[tokenId];
        royaltyAmount = (salePrice * royaltyFee) / ROYALTY_FEE_BASE;
    }
}
