//SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;


//openzeppelin ERC721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//security against transactions for multiple requests
import "hardhat/console.sol";

contract BirdsMarket is ReentrancyGuard {
    using Counters for Counters.Counter;

    //number of items minting, number of transactions, tokens that have not been sold
    //keep track of tokens total number - tokenId
    Counters.Counter private _tokenIds;
    Counters.Counter private _tokenSold;

    address payable owner;

    uint256 listingPrice = 0.045 ether;

    struct MarketToken {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketToken) private idToMarketToken;

    //events
    event MarketTokenMinted(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() {
        owner = payable(msg.sender);
    }

    //get listing price
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint price
    ) public payable nonReentrant{
        require(price > 0 , "Price should be at least one wei");
        require(msg.value == listingPrice, "Prie must be equal to listing price");

        _tokenIds.increment();
        uint itemId = _tokenIds.current();

        idToMarketToken[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        //NFT transaction
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketTokenMinted(itemId, nftContract, tokenId, msg.sender, address(0), price, false);
    }

    function createMarketSale(
        address nftContract,
        uint itemId
    ) public payable nonReentrant {
        uint price = idToMarketToken[itemId].price;
        uint tokenId = idToMarketToken[itemId].tokenId;
        require(msg.value == price, "Please submit the asking price in order to continue");

        //transfer the amount to the seller
        idToMarketToken[itemId].seller.transfer(msg.value);

        //transfer the token from contract address to the buyer
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        idToMarketToken[itemId].owner = payable(msg.sender);
        idToMarketToken[itemId].sold = true;
        _tokenSold.increment();

        payable(owner).transfer(listingPrice);
    }
}

