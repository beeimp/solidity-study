# 크립토좀비

## 목표

- [크립토 좀비](https://cryptozombies.io/ko/)를 단계별로 수행하면서 솔리디티의 최신 버전으로 구현하기

## 커리큘럼

### Solidity Path: Beginner to Intermediate Smart Contracts

1. 좀비 공장 만들기
   * contract
   * 상태 변소 & 정수
   * 수학 연산
   * 구조체
   * 배열
   * 함수 선언
   * 구조체와 배열 활용
   * Private / Public
   * Keccak256
2. 좀비가 희생물을 공격하다
   * 매핑과 주소
   * msg.sender
   * require
   * 상속
   * import
   * storage vs memory
   * 함수 접근 제어자
   * 인터페이스 활용
   * 다수의 반환값 처리
3. 고급 솔리티디 개념
   * 컨트랙트의 불변성
       *  컨트랙트에 문제가 생기면 해당 주소를 바꿀 수 있도록 해주는 함수 생성
   * 소유 가능한 컨트랙트
       * Constructor
       * Function Modifier
       * Indexed
   * onlyOwner 함수 제어자
       * 함수에 적용 시 `_;` 부분에서 함수 실행
   * Gas
       * 가스 비용(Gas Cost)은 그 함수를 구성하는 개별 연산들의 가스 비용을 모두 합친 것
   * 시간 단위
       * 유닉스 타임스탬프
   * 좀비 재사용 대기 시간
       * 재사용 대기 시간 타이머를 구현
   * Public 함수 & 보안
       * 함수 남용 방지 - internal
   * 함수 제어자의 또 다른 특징
       * 함수 제어자에 인수 전달
   * 좀비 제어자
   * View 함수를 사용해 가스 절약하기
       * view 함수는 가스를 소모하지 않음
       * 가스 사용을 최적화 - 읽기 전용의 `external view` 함수를 쓰는 것
   * 비싼 Storage
       * 데이터의 일부를 쓰거나 바꿀 때마다 영구적으로 기록되어 연산 비용 높음
       * 필요한 경우가 아니면 사용하지 말것
   * For 반복문
       * 장점 - 구현이 간담함
       * 문제 - 가스 소모 측정에 어려움
       * 필요하다면 view 함수에서 사용하여 전제적인 가스 비용 소모 낮추기