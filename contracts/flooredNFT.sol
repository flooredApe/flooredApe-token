// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "../contracts/Counters.sol";

contract FlooredApe is ERC721, ERC721URIStorage, Pausable, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant OG_ROLE = keccak256("OG_ROLE");

    Counters.Counter private _tokenIdCounter; 
    Counters.Counter private _ogTokenIdCounter;
    uint256 public MINT_RATE = 0.02 ether;
    uint256 public MAX_SUPPLY = 50001;
    
    
    constructor() ERC721("FlooredApe", "FA") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(OG_ROLE, msg.sender);
        _tokenIdCounter.setCounter();
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) whenNotPaused payable {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "Tokens are sold out.");
        require(msg.value >= MINT_RATE, "Not enough ether.");
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), uri); 
        _tokenIdCounter.increment();
    }

    function ownerMint(address to, string memory uri) public onlyRole(DEFAULT_ADMIN_ROLE) payable { //for airdrop
        require(_ogTokenIdCounter.current() < 1001, "OG Tokens are sold out");
        _safeMint(to, _ogTokenIdCounter.current());
        _setTokenURI(_ogTokenIdCounter.current(), uri); 
        _ogTokenIdCounter.increment();
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }



}
