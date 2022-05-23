// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14; //SolidityPath-lesson01-ch02-01: 솔리디티 버전 입력

// SolidityPath-lesson02-ch06: Import
import "./ZombieFactory.sol";

// SolidityPath-lesson02-ch10: 크립토키티
interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

// SolidityPath-lesson02-ch05: 상속
// -> SolidityPath-lesson02-ch13: 키티 유전자 - _species 추가
contract ZombieFeeding is ZombieFactory {
    // SolidityPath-lesson02-ch11: 인터페이스 활용
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // `ckAddress`를 이용하여 여기에 kittyContract를 초기화
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // SolidityPath-lesson02-ch07: storage vs Memory
    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        require(zombieToOwner[_zombieId] == msg.sender);
        Zombie storage _myZombie = zombies[_zombieId];
        // SolidityPath-lesson02-ch08: 좀비 DNA
        _targetDna %= dnaModulus;
        uint256 _newDna = (_myZombie.dna + _targetDna) * 2;

        // SolidityPath-lesson02-ch13: 해시값 비교 if문과 끝자리 99로 변경
        if (
            keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))
        ) {
            _newDna = _newDna - (_newDna % 100) + 99;
        }
        _createZombie("NoName", _newDna);
    }

    // SolidityPath-lesson02-ch12: 다수의 반환값 처리
    // -> SolidityPath-lesson02-ch13: 키티 유전자
    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 _kittyDna;
        (, , , , , , , , , _kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, _kittyDna, "kitty");
    }
}
