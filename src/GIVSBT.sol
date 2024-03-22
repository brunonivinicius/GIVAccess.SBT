// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GIVSBT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => bool) _locked;

    constructor(address initialOwner)
        ERC721("GivCertificate", "GivC")
        Ownable(initialOwner)
    {}

    event Locked(uint256 tokenId);

    function locked(uint256 tokenId) external view returns (bool) {
        require(ownerOf(tokenId) != address(0));
        return _locked[tokenId];
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        require(balanceOf(to) == 0, "ja possui algum token deste contrato");
        uint256 tokenId = _nextTokenId++;
        _locked[tokenId] = true;
        emit Locked(tokenId);
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }
    
    function ownsToken(address user) public view returns (bool) {
        return balanceOf(user) > 0;
    }

    function balanceToken(address user) public view returns (uint256) {
        return balanceOf(user);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721)
        returns (address)
    {
        address from = _ownerOf(tokenId);
    if (from != address(0)) {
        revert("Transfer not allowed");  // Prevent all transfers, making the token soulbound and non-burnable
    }
        return super._update(to, tokenId, auth);
    }

    // Required overrides  

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}


//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) public virtual override pure {
//         revert("Transfer not allowed");
//     }

//     function transferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) public virtual override pure {
//         revert("Transfer not allowed");
//     }
// }

// Remova as funções approve e setApprovalForAll
// function approve(address, uint256) public virtual override pure {
//     revert("Approval not allowed");
// }

// function setApprovalForAll(address, bool) public virtual override pure {
//     revert("Approval not allowed");
// }