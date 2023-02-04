// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import 'hardhat/console.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

string constant name = "BasicNFT";
string constant symbol = "BNFT";

contract BasicNFT is ERC721(name, symbol){
    //The library of String operations and used here for uint256
    using Strings for uint256;
    
    //Total Supply of the NFTs, updated only after function mintAll is called
    uint256 public totalSupply;

    address owner;

    // Array holding each NFT's tokenId and uri
    struct AllMints {
        uint256 _tokenId;
        string _uri;
    }

    // This function runs only once at the beginning and running of the contract
    constructor() {
        owner = msg.sender;
    }

    // This enforces that the msg.sender must be same address as the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, 'Must be BasicNFT deployer');
        _;
    }

    // An Internal function overriding the parent function _baseURI() from ERC721 for
    // returning the base URI unto which tokenId is added to give URL of each NFT
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://ipfs.io/ipfs/QmSrSwboxekwhUfK5nKcbzK6xuTmNxhsiz643pmjqJfqPt/";
    }
    
    // The publicly viewable function returning the baseURI
    function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    // The Function which mints the ERC721 tokens according to the owner input in loop
    function mintAll(bytes memory data, uint256 total) onlyOwner 
    public payable returns (AllMints[] memory) {

        AllMints[] memory allMints = new AllMints[](total + 1);
        for (uint256 i = 1; i < (total + 1); i++) {

            string memory _uri = string(
                abi.encodePacked(_baseURI(), Strings.toString(i), ".jpg")
            );
            console.log(_uri);
            _safeMint(msg.sender, i, data);
            allMints[i] = AllMints(i, _uri);
            totalSupply++;
        }
        return allMints;
    }
}