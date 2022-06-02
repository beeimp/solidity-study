// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; //SolidityPath-lesson01-ch02-01: 솔리디티 버전 입력

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
    // SolidityPath-lesson03-ch01: 컨트랙트의 불변성 - 해당 줄 삭제
    /*
     * // SolidityPath-lesson02-ch11: 인터페이스 활용
     * address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // `ckAddress`를 이용하여 여기에 kittyContract를 초기화
     */
    
    // SolidityPath-lesson03-ch01: 컨트랙트의 불변성 - 선언만 
    /*
     * KittyInterface kittyContract = KittyInterface(ckAddress);
     */
    KittyInterface kittyContract;

    // SolidityPath-lesson03-ch01: 컨트랙트의 불변성 - setKittyContractAddress 메소드 추가
    // SolidityPath-lesson03-ch03: onlyOwner 함수 제어자
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // SolidityPath-lesson03-ch06: 좀비 재사용 대기 시간 (1) - `_triggerCooldown` 함수 정의
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    // SolidityPath-lesson03-ch06: 좀비 재사용 대기 시간 (1) - `_isReady` 함수 정의
    function _isReady(Zombie storage _zombie) internal view returns(bool) {
        return (_zombie.readyTime <= block.timestamp);
    }
    
    // SolidityPath-lesson02-ch07: storage vs Memory
    // -> SolidityPath-lesson03-ch07: Public 함수 & 보안 (1) - public -> internal
    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) internal {
        require(zombieToOwner[_zombieId] == msg.sender);
        Zombie storage _myZombie = zombies[_zombieId];
        // SolidityPath-lesson02-ch08: 좀비 DNA
        // -> SolidityPath-lesson03-ch07: Public 함수 & 보안 (2) - `_isReady` 확인
        require(_isReady(_myZombie));
        _targetDna %= dnaModulus;
        uint256 _newDna = (_myZombie.dna + _targetDna) * 2;

        // SolidityPath-lesson02-ch13: 해시값 비교 if문과 끝자리 99로 변경
        if (
            keccak256(abi.encode(_species)) == keccak256(abi.encode("kitty"))
        ) {
            _newDna = _newDna - (_newDna % 100) + 99;
        }
        _createZombie("NoName", _newDna);
        // SolidityPath-lesson03-ch07: Public 함수 & 보안 (3) - `_triggerCooldown`을 호출하게
        _triggerCooldown(_myZombie);
    }

    // SolidityPath-lesson02-ch12: 다수의 반환값 처리
    // -> SolidityPath-lesson02-ch13: 키티 유전자
    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 _kittyDna;
        (, , , , , , , , , _kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, _kittyDna, "kitty");
    }
}
