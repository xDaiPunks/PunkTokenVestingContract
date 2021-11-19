/**
 *  _______                    __            __     __                     __     __
 * |       \                  |  \          |  \   |  \                   |  \   |  \
 * | ▓▓▓▓▓▓▓\__    __ _______ | ▓▓   __     | ▓▓   | ▓▓ ______   _______ _| ▓▓_   \▓▓_______   ______
 * | ▓▓__/ ▓▓  \  |  \       \| ▓▓  /  \    | ▓▓   | ▓▓/      \ /       \   ▓▓ \ |  \       \ /      \
 * | ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓▓\ ▓▓_/  ▓▓     \▓▓\ /  ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓▓\▓▓▓▓▓▓ | ▓▓ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\
 * | ▓▓▓▓▓▓▓| ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓   ▓▓       \▓▓\  ▓▓| ▓▓    ▓▓\▓▓    \  | ▓▓ __| ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓
 * | ▓▓     | ▓▓__/ ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓\        \▓▓ ▓▓ | ▓▓▓▓▓▓▓▓_\▓▓▓▓▓▓\ | ▓▓|  \ ▓▓ ▓▓  | ▓▓ ▓▓__| ▓▓
 * | ▓▓      \▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  \▓▓\        \▓▓▓   \▓▓     \       ▓▓  \▓▓  ▓▓ ▓▓ ▓▓  | ▓▓\▓▓    ▓▓
 *  \▓▓       \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓   \▓▓         \▓     \▓▓▓▓▓▓▓\▓▓▓▓▓▓▓    \▓▓▓▓ \▓▓\▓▓   \▓▓_\▓▓▓▓▓▓▓
 *                                                                                           |  \__| ▓▓
 *                                                                                            \▓▓    ▓▓
 *                                                                                             \▓▓▓▓▓▓
 *
 * $PUNK VESTING
 *
 */

pragma solidity 0.8.0;

/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * xDaiPunks
 * Copyright (C) 2021 xDaiPunks
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "../Interface/IPunks.sol";

/**
 * @title PunkVesting
 * @dev The vesting contract that makes the $PUNK token claimable in a linear fashion based the Punks NFT contract.
 * Vesting is based on block.timestamp and the vesting timespan. Claims are dependent on the Punks that are owned
 * by a particular address
 */

contract PunkVesting is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /**
     * @dev Claim event for $PUNK. Based on single NFT
     */
    event ClaimedPunkToken(
        address owner,
        uint256 total,
        uint256 punk,
        uint256 punkAmount
    );

    /**
     * @dev Claim event for $PUNK. Based on single array of NFTs
     */
    event ClaimedPunkTokens(
        address owner,
        uint256 total,
        uint256[] punks,
        uint256[] punkAmounts
    );

    uint256 public cliff;
    uint256 public start;
    uint256 public duration;

    uint256 public punkAvailable;
    uint256 public totalAvailable;

    IERC20 public immutable Punk;
    IPunks public immutable Punks;

    mapping(uint256 => uint256) public punkClaimed;

    /**
     * @dev Sets the values for {duration}, {cliff}, {start}, {totalAvailable}, {punkAvailable}, {Punk} and {Punks}.
     *
     * @param _start: unix time of the start of $PUNK vesting
     * @param _cliff: delayed start of $PUNK vesting in seconds
     * @param _duration: timespan of $PUNK vesting in seconds
     * @param _totalAvailable: total available supply of the $PUNK token
     * @param _Punk: contract address of the $PUNK ERC20 contract
     * @param _Punks: interface of the Punks NFT contract
     */
    constructor(
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _totalAvailable,
        IERC20 _Punk,
        IPunks _Punks
    ) {
        duration = _duration;
        cliff = _start.add(_cliff);
        start = _start;

        totalAvailable = _totalAvailable;
        punkAvailable = _totalAvailable.div(10000);

        Punk = _Punk;
        Punks = _Punks;
    }

    /**
     * @dev Claims the $PUNK tokens available for claim for the msg.sender.
     *
     * Claim is a linear devision of the claimable amount and vesting timespan
     * Claim is per owned NFT
     * Claim also claims the unclaimed $PUNK
     */
    function claim() external nonReentrant {
        uint256 tokenId;
        uint256 nftCount;

        uint256 claimed;
        uint256 available;

        uint256 claimAmount;
        uint256 availableClaim;

        claimAmount = 0;

        nftCount = Punks.balanceOf(msg.sender);

        if (nftCount == 0) {
            uint256[] memory punks = new uint256[](0);
            uint256[] memory punkAmounts = new uint256[](0);

            emit ClaimedPunkTokens(msg.sender, claimAmount, punks, punkAmounts);
        } else {
            uint256[] memory punks = new uint256[](nftCount);
            uint256[] memory punkAmounts = new uint256[](nftCount);

            for (uint256 i = 0; i < nftCount; i++) {
                tokenId = Punks.tokenOfOwnerByIndex(msg.sender, i);

                punks[i] = tokenId;
                claimed = punkClaimed[tokenId];

                if (block.timestamp >= start.add(duration)) {
                    available = punkAvailable;
                } else {
                    available = punkAvailable
                        .mul(block.timestamp.sub(start))
                        .div(duration);
                }

                if (claimed == 10_000e18 || claimed > available) {
                    availableClaim = 0;
                } else {
                    availableClaim = available.sub(claimed);
                }

                punkAmounts[i] = availableClaim;

                claimAmount += availableClaim;
                punkClaimed[tokenId] += availableClaim;
            }

            Punk.safeTransfer(msg.sender, claimAmount);

            emit ClaimedPunkTokens(msg.sender, claimAmount, punks, punkAmounts);
        }
    }

    /**
     * @dev Claims the $PUNK tokens available for an individual NFT
     *
     * Claim is a linear devision of the claimable amount and vesting timespan
     * Claim is per owned NFT
     * Claim also claims the unclaimed $PUNK
     */
    function claimPunk(uint256 tokenId) external nonReentrant {
        uint256 claimed;
        uint256 available;

        uint256 claimAmount;
        uint256 availableClaim;

        require(
            msg.sender == Punks.ownerOf(tokenId),
            "Sender is not owner of NFT"
        );

        claimed = punkClaimed[tokenId];

        if (block.timestamp >= start.add(duration)) {
            available = punkAvailable;
        } else {
            available = punkAvailable.mul(block.timestamp.sub(start)).div(
                duration
            );
        }

        if (claimed == 10_000e18 || claimed > available) {
            availableClaim = 0;
        } else {
            availableClaim = available.sub(claimed);
        }

        claimAmount = availableClaim;
        punkClaimed[tokenId] += availableClaim;

        Punk.safeTransfer(msg.sender, claimAmount);

        emit ClaimedPunkToken(msg.sender, claimAmount, tokenId, claimAmount);
    }

    /**
     * @dev Gets the total claim available of an address
     *
     * Claim is a linear devision of the claimable amount and vesting timespan
     * Claim is per owned NFT
     * Claim also claims the unclaimed $PUNK
     */
    function claimAvailable(address owner) public view returns (uint256) {
        uint256 tokenId;
        uint256 nftCount;

        uint256 claimed;
        uint256 available;

        uint256 claimAmount;
        uint256 availableClaim;

        claimAmount = 0;

        nftCount = Punks.balanceOf(owner);

        if (nftCount == 0) {
            return claimAmount;
        } else {
            for (uint256 i = 0; i < nftCount; i++) {
                tokenId = Punks.tokenOfOwnerByIndex(owner, i);

                claimed = punkClaimed[tokenId];

                if (block.timestamp >= start.add(duration)) {
                    available = punkAvailable;
                } else {
                    available = punkAvailable
                        .mul(block.timestamp.sub(start))
                        .div(duration);
                }

                if (claimed == 10_000e18 || claimed > available) {
                    availableClaim = 0;
                } else {
                    availableClaim = available.sub(claimed);
                }

                claimAmount += availableClaim;
            }

            return claimAmount;
        }
    }

    /**
     * @dev Gets the total claim available of an individual NFT
     *
     * Claim is a linear devision of the claimable amount and vesting timespan
     * Claim is per owned NFT
     * Claim also claims the unclaimed $PUNK
     */
    function claimAvailablePunk(uint256 tokenId) public view returns (uint256) {
        uint256 claimed;
        uint256 available;

        uint256 availableClaim;

        if (block.timestamp >= start.add(duration)) {
            available = punkAvailable;
        } else {
            available = punkAvailable.mul(block.timestamp.sub(start)).div(
                duration
            );
        }

        if (tokenId < 1 || tokenId > 10000) {
            availableClaim = 0;
        } else {
            claimed = punkClaimed[tokenId];

            if (claimed == 10_000e18 || claimed > available) {
                availableClaim = 0;
            } else {
                availableClaim = available.sub(claimed);
            }
        }

        return availableClaim;
    }
}
