// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.14;

contract CrowdFunding {
    // 이벤트 정의
    event FundrisingSuccessful(uint256 _amount);
    event Refund(address _addr, uint256 _amount);

    enum fundingSatus {
        FUNDING,
        SUCCESS,
        FAILURE
    }

    // State 변수 선언
    address payable public owner; // 계약의 소유자
    uint256 public nInvestors; // 투자자의 수
    uint256 public deadline; // 데드라인 (Unix 타임)
    fundingSatus public status; // 모금 활동 상태
    bool public isEnded; // 모금 종료 여부
    uint256 public goalAmount; // 목표 금액
    uint256 public totalAmount; // 총 투자금액

    // 생성자
    constructor(uint256 _duration, uint256 _goalAmount) {
        owner = payable(msg.sender); // 계약의 주인 주소 설정
        deadline = block.timestamp + _duration; // 데드라인 설정
        goalAmount = _goalAmount;
        status = fundingSatus.FUNDING;
        isEnded = false;
        nInvestors = 0; // 투자자수 초기화
        totalAmount = 0; // 총 모금액 초기화
    }

    // 투자자 Struct
    struct Investor {
        address addr; // 투자자의 주소
        uint256 amount; // 투자 금액
    }

    mapping(uint256 => Investor) public investors; // 투자자 관리 매핑

    // 사용자 정의 modifier - 배포할 때 사용한 주소만 접근
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    // 투자시 호출되는 함수
    receive() external payable {
        require(!isEnded); // 모금이 끝났으면 중단
        Investor memory newInvestor = Investor(msg.sender, msg.value);
        investors[nInvestors++] = newInvestor; // 투자자 1명 추가
        totalAmount += msg.value; // 총 모금액 증가
    }

    // 목표액 달성여부 확인.
    // 모금 달성/실패 여부에 따라서 환불 진행.
    function checkGoalReached() public payable isOwner {
        require(!isEnded); // 모금이 끝났다면 오류 발생
        require(block.timestamp >= deadline); // 마감 기간을 초과한 경우 오류 발생

        isEnded = true;
        if (totalAmount >= goalAmount) {
            // 모금 성공
            status = fundingSatus.SUCCESS;
            // 계약의 주인에게 모든 금액 송금
            owner.transfer(address(this).balance);
            emit FundrisingSuccessful(totalAmount);
        } else {
            // 모금 실패.
            status = fundingSatus.FAILURE;
            for (uint256 i = 0; i < nInvestors; i++) {
                payable(investors[i].addr).transfer(investors[i].amount);
                emit Refund(investors[i].addr, investors[i].amount);
            }
        }
    } // 함수 끝

    // 잔여시간
    function timeLeft() public view returns (uint256) {
        require(!isEnded); // 모금이 끝나면 중단!
        return deadline - block.timestamp;
    }
} 
