// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FlooredApe is ERC721, ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public MINT_RATE = 0.02 ether;
    uint public MAX_SUPPLY = 50000;
    
    constructor() ERC721("FlooredApe", "FA") {}

    function renounce() public onlyOwner {
        _renounceOwnership(); //from Ownable.sol
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public payable {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Tokens are sold out.");
        require(msg.value >= MINT_RATE, "Not enough ether.");
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), uri); 
        _tokenIdCounter.increment();
        }
    }

    function ownerMint(address to, string memory uri) onlyOwner { //for airdrop
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), uri); 
        _tokenIdCounter.increment();
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function contractURI() public pure returns (string memory) {
        return "https://flooredape.mypinata.cloud/ipfs/QmXhYrXmaCoWxGFXfwW7YsnYGze4jFzubtPP5oWousbe1K";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    


}
