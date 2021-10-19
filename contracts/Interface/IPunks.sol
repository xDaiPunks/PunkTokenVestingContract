// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the Punks NFT contract.
 */

interface IPunks {
    /**
     * @dev Gets address of current owner of the tokenId.
     *
     * @param tokenId: tokenId of the NFT
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Returns the index length of the NFTs owned by the the address
     * This is an override balanceOf of the regular balanceOf
     * 
     * @param _owner: address of the owner
     */
    function balanceOf(address _owner) external view returns (uint256);

    /**
     * @dev Returns the tokenId of the NFT owned by the the address at a given index
     * 
     * @param _owner: address of the owner
     * @param _index: index of the NFT. Can be found using the balanceOf function
     */
    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        external
        view
        returns (uint256);
}
