// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    // 해당 스마트 컨트랙트 기반 ERC-20 토큰의 총 발행량 확인
    function totalSupply() external view returns (uint256);

    // owner가 가지고 있는 토큰의 보유량 확인
    function balanceOf(address account) external view returns (uint256);

    // owner가 spender에게 양도 설정한 토큰의 양을 확인
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    // 토큰을 전송
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    // spender에게 value 만큼의 토큰을 인출할 권리를 부여. 이 함수를 이용할 때는 반드시 Approval 이벤트 함수를 호출해야 함
    function approve(address spender, uint256 amount) external returns (bool);

    // spender가 거래 가능하도록 양도 받은 토큰을 전송
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// SafeMath 라이브러리 추가
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        assert(b != 0);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

abstract contract OwnerHelper {
  event OwnershipTransferred(address indexed preOwner, address indexed nextOwner);
  
  address private _owner;

  constructor () {
    _owner = msg.sender;
  }

  modifier onlyOwner{
    require(msg.sender == _owner, "OwnerHelper: caller is not owner");
    _;
  }

  function owner() public virtual view returns(address) {
    return _owner;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != _owner);
    require(_newOwner != address(0));
    address _preOwner = _owner;
    _owner = _newOwner;
    emit OwnershipTransferred(_preOwner, _newOwner);
  }
}

contract ERC20Basic is IERC20, OwnerHelper {
    using SafeMath for uint256; // uint256으로 선언된 함수에 대해서 SafeMath Library를 이용해서 해당 함수를 사용

    string public constant name = "ERC20Basic";
    string public constant symbol = "BEE";
    uint8 public constant decimals = 18;
    bool private _tokenLock; // TokenLock

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    mapping (address => bool) _personalTokenLock; // TokenLock

    uint256 totalSupply_ = 10000 ether;

    constructor() {
        balances[msg.sender] = totalSupply_;
        _tokenLock = true;
    }

    function isTokenLock(address _from, address _to) public view returns(bool) {
      if(_tokenLock == true){
        return true;
      }
      if(_personalTokenLock[_from] == true || _personalTokenLock[_to] == true) {
        return true;
      }
      return false;
    }

    // 다음의 코드에서 함수로 전달되는 파라미터 브라켓 뒤에 오는 onlyOwner가 예시
    function removeTokenLock() onlyOwner public {
        require(_tokenLock);
        _tokenLock = false;
    }

    // 다음의 코드에서 함수로 전달되는 파라미터 브라켓 뒤에 오는 onlyOwner가 예시입니다.
    function removePersonalTokenLock(address _who) onlyOwner public {
        require(_personalTokenLock[_who] == true);
        _personalTokenLock[_who] = false;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        require(isTokenLock(msg.sender, receiver) == false, "TokenLock: invalid token transfer");
        balances[msg.sender] = balances[msg.sender].sub(numTokens); // SafeMath 사용
        balances[receiver] = balances[receiver].add(numTokens); // SafeMath 사용
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        require(isTokenLock(owner, buyer) == false, "TokenLock: invalid token transfer"); // Token Lock

        balances[owner] = balances[owner].sub(numTokens); // SafeMath 사용
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens); // SafeMath 사용
        balances[buyer] = balances[buyer].add(numTokens); // SafeMath 사용
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
