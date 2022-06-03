// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // SolidityPath-lesson03-ch08: 함수 제어자의 또 다른 특징 - 매개변수
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // SolidityPath-lesson03-ch09: 좀비 제어자 (1)
    function chaneName(uint256 _zombieId, string memory _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    // SolidityPath-lesson03-ch09: 좀비 제어자 (2)
    function chaneDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    // SolidityPath-lesson03-ch10: 'View' 함수를 사용해 가스 절약하기
    function getZombieByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        // SolidityPath-lesson03-ch11: Storage는 비싸다
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        // SolidityPath-lesson03-ch12: For 반복문
        uint counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
              result[counter++] = i;
            }
        }

        return result;
    }
}
