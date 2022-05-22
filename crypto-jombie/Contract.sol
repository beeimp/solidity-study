// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14; //SolidityPath-lesson01-ch02-01: 솔리디티 버전 입력

// SolidityPath-lesson01-ch02-02: 컨트랙트 생성
contract ZombieFactory {
  // SolidityPath-lesson01-ch14-01: event 선언
  event NewZombie(uint zombieId, string name, uint dna);

  // SolidityPath-lesson01-ch03: 상태 변수 & 정수
  uint dnaDigits = 16; // 16자리 uint의 DNA
  // SolidityPath-lesson01-ch04: 수학 연산
  uint dnaModulus = 10 ** dnaDigits;

  // SolidityPath-lesson01-ch05: 구조체
  struct Zombie {
    string name;
    uint dna;
  }

  // SolidityPath-lesson01-ch06: 배열
  Zombie[] public zombies; // public한 동적 배열 선언
  // SolidityPath-lesson01-ch07: 함수 선언 -> // SolidityPath-lesson01-ch09: public -> private
  function _createZombie(string memory _name, uint _dna) private {
    // SolidityPath-lesson01-ch08: 구조체와 배열 활용
    zombies.push(Zombie({
      name: _name, 
      dna: _dna
    }));
    // SolidityPath-lesson01-ch13-02: event 실행
    uint _id = zombies.length;
    emit NewZombie(_id, _name, _dna);
  }

  // SolidityPath-lesson01-ch10: 함수 활용
  function _generateRandomDna(string memory _str) private view returns(uint) {
    // SolidityPath-lesson01-ch11-Keccak256과 형 변환
    uint _rand = uint(keccak256(bytes(_str)));
    return _rand % dnaModulus;
  }

  // SolidityPath-lesson01-ch11: 종합
  function createRandomZombie(string memory _name) public {
    uint _randDna = _generateRandomDna(_name);
    _createZombie(_name, _randDna);
  }
}