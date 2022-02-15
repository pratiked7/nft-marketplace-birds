//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

//openzeppelin ERC721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Objective: Give the NFT market the ability to transact with tokens or change ownership
// setApprovalForAll allows us to do that with contract address
contract NFT is ERC721URIStorage {
    // counters allow us to keep track of token ids
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // address of marketplace for NFTs to interact
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("Birds", "BIRDS"){
        contractAddress = marketplaceAddress;
    }

    function mintToken(string memory tokenURI) public returns(uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        //caller address, newItemId
        _mint(msg.sender, newItemId);
        // set the token URI: id and url
        _setTokenURI(newItemId, tokenURI);
        //give the marketplace the approval to transact between users
        setApprovalForAll(contractAddress, true);
        //mint the token and set it for sale 
        return newItemId; 
    }
}