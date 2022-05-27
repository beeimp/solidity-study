// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@klaytn/contracts/contracts/KIP/token/KIP17/KIP17.sol";
import "@klaytn/contracts/contracts/utils/Counters.sol";
import "@klaytn/contracts/contracts/access/Ownable.sol";
import "@klaytn/contracts/contracts/KIP/token/KIP17/extensions/KIP17URIStorage.sol";

contract MyNFT is Ownable, KIP17URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() KIP17("MyKlaytnNFT-BI-v2", "MKN") {}

    function mintNFT(address recipient, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}
