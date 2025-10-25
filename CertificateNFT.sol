// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title CertificateNFT
 * @dev An ERC721 token contract for issuing and verifying certificates.
 * Each token represents a unique, non-fungible certificate.
 * The contract owner (the institution) is the only one who can mint new certificates.
 */
contract CertificateNFT is ERC721, ERC721Enumerable, Ownable {
    // Counter to keep track of the next token ID to be minted.
    uint256 private _nextTokenId;

    // Struct to hold the metadata for each certificate.
    struct Certificate {
        string recipientName;
        string courseName;
        uint256 issueDate;
    }

    // Mapping from a token ID to its corresponding certificate details.
    mapping(uint256 => Certificate) private _certificateDetails;

    /**
     * @dev Constructor to initialize the NFT contract.
     * @param initialOwner The wallet address of the institution that will own the contract.
     */
    constructor(address initialOwner)
        ERC721("CertificateNFT", "CERT")
        Ownable(initialOwner)
    {}

    /**
     * @dev Mints a new certificate NFT and assigns it to a recipient.
     * Can only be called by the contract owner.
     * @param recipient The wallet address of the person receiving the certificate.
     * @param recipientName The full name of the recipient.
     * @param courseName The name of the course or qualification.
     */
    function mintCertificate(
        address recipient,
        string memory recipientName,
        string memory courseName
    ) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(recipient, tokenId);

        // Store the certificate metadata on the blockchain.
        _certificateDetails[tokenId] = Certificate({
            recipientName: recipientName,
            courseName: courseName,
            issueDate: block.timestamp
        });
    }

    /**
     * @dev Retrieves the details of a certificate by its token ID.
     * This is a public view function, so anyone can call it without a transaction fee.
     * @param tokenId The ID of the certificate NFT.
     * @return A tuple containing the recipient's name, course name, and issue date.
     */
    function getCertificateDetails(uint256 tokenId)
        public
        view
        returns (string memory, string memory, uint256)
    {
        require(_exists(tokenId), "CertificateNFT: URI query for nonexistent token");
        Certificate memory cert = _certificateDetails[tokenId];
        return (cert.recipientName, cert.courseName, cert.issueDate);
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
