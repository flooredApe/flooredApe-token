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
    bool public publicBool = false;
    bool public whiteListBool = false;
    bool public adminBool = false;


    Counters.Counter private _tokenIdCounter; 
    Counters.Counter private _ogTokenIdCounter;

    uint256 public MINT_RATE = 0.02 ether;
    
    constructor() ERC721("flooredApe", unicode"🐵") {
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

    function safeMint(address to, string memory uri, uint amount) public payable {
        require(publicBool, "Function not currently accessible");
        require(_tokenIdCounter.current() < 50001, "Tokens are sold out.");
        require(msg.value >= amount * MINT_RATE, "Not enough ether.");

        for (uint i=0; i < amount; i++)
        {
            _safeMint(to, _tokenIdCounter.current());
            _setTokenURI(_tokenIdCounter.current(), uri); 
            _tokenIdCounter.increment();
        }

        
    }

    function whiteListMint(address to, string memory uri, uint amount) public onlyRole(MINTER_ROLE) payable {
        require(whiteListBool, "Function not currently accessible");
        require(_tokenIdCounter.current() < 50001, "Tokens are sold out.");
        require(msg.value >= amount * MINT_RATE, "Not enough ether.");

        for (uint i=0; i < amount; i++)
        {
            _safeMint(to, _tokenIdCounter.current());
            _setTokenURI(_tokenIdCounter.current(), uri); 
            _tokenIdCounter.increment();
        }

        
    }

    function ownMint(address to, string memory uri, uint amount) public onlyRole(DEFAULT_ADMIN_ROLE) payable { //for airdrop
        require(adminBool, "Function not currently accessible");
        require(_ogTokenIdCounter.current() < 1001, "OG Tokens are sold out");
        
        for (uint i=0; i < amount; i++)
        {
            _safeMint(to, _ogTokenIdCounter.current());
            _setTokenURI(_ogTokenIdCounter.current(), uri); 
            _ogTokenIdCounter.increment();
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

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function batchRole (bytes32 role, address[] memory arr) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        for(uint i=0; i < arr.length; i++)
        {
        grantRole(role, arr[i]);
        }
    }

    function batchRevoke (bytes32 role, address[] memory arr) public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        for(uint i=0; i < arr.length; i++)
        {
        revokeRole(role, arr[i]);
        }
    }

    function currentPublic() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function currentOg() public view returns (uint256) {
        return _ogTokenIdCounter.current();
    }

    function flipPublic() internal onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if(publicBool)
            publicBool = false;
        else
            publicBool = true;
    }
    function flipWhiteList() public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if(whiteListBool)
            whiteListBool = false;
        else
            whiteListBool = true;
    }
    function flipOwner() public onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if(adminBool)
            adminBool = false;
        else
            adminBool = true;
    }

}
