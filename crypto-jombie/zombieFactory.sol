// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14; //SolidityPath-lesson01-ch02-01: 솔리디티 버전 입력

// SolidityPath-lesson03-ch02: 소유 가능한 컨트랙트 - import Ownable
import "./Ownable.sol";

// SolidityPath-lesson01-ch02-02: 컨트랙트 생성
// SolidityPath-lesson03-ch02: 소유 가능한 컨트랙트 - Ownable 상속
contract ZombieFactory is Ownable {
  // SolidityPath-lesson01-ch14-01: event 선언
  event NewZombie(uint zombieId, string name, uint dna);

  // SolidityPath-lesson01-ch03: 상태 변수 & 정수
  uint dnaDigits = 16; // 16자리 uint의 DNA
  // SolidityPath-lesson01-ch04: 수학 연산
  uint dnaModulus = 10 ** dnaDigits;
  // SolidityPath-lesson03-ch05: 시간 단위 (1)
  uint cooldownTime = 1 days;

  // SolidityPath-lesson01-ch05: 구조체
  // -> SolidityPath-lesson03-ch04: 가스(Gas) - 구조체 요소 추가
  struct Zombie {
    string name;
    uint dna;
    uint32 level;
    uint32 readyTime; // 유닉스 타임 - 일반적으로 32bit
  }

  // SolidityPath-lesson01-ch06: 배열
  Zombie[] public zombies; // public한 동적 배열 선언

  // SolidityPath-lesson02-ch02: 매핑과 주소
  mapping (uint=>address) public zombieToOwner;
  mapping (address=>uint) ownerZombieCount;

  // SolidityPath-lesson01-ch07: 함수 선언
  // -> SolidityPath-lesson01-ch09: public -> private
  // -> SolidityPath-lesson02-ch09: private -> internal
  function _createZombie(string memory _name, uint _dna) internal {
    // SolidityPath-lesson01-ch08: 구조체와 배열 활용
    zombies.push(Zombie({
      name: _name, 
      dna: _dna,
      level: 1,
      readyTime: uint32(block.timestamp + cooldownTime) // SolidityPath-lesson03-ch05: 시간 단위 (2) - now -> block.timestamp
    }));
    // SolidityPath-lesson01-ch13-02: event 실행
    uint _id = zombies.length;
    emit NewZombie(_id, _name, _dna);

    // SolidityPath-lesson02-ch03: msg.sender
    zombieToOwner[_id] = msg.sender;
    ownerZombieCount[msg.sender] += 1;
  }

  // SolidityPath-lesson01-ch10: 함수 활용
  function _generateRandomDna(string memory _str) private view returns(uint) {
    // SolidityPath-lesson01-ch11-Keccak256과 형 변환
    uint _rand = uint(keccak256(bytes(_str)));
    return _rand % dnaModulus;
  }

  // SolidityPath-lesson01-ch11: 종합
  function createRandomZombie(string memory _name) public {
    // SolidityPath-lesson02-ch04: Require
    require(ownerZombieCount[msg.sender] == 0);
    uint _randDna = _generateRandomDna(_name);
    _createZombie(_name, _randDna);
  }
}