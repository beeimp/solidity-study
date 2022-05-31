// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

abstract contract OwnerHelper {
    address private owner;

    event OwnerTransferPropose(address indexed _from, address indexed _to);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transferOwnership(address _to) public onlyOwner {
        require(_to != owner);
        require(_to != address(0x0));
        owner = _to;
        emit OwnerTransferPropose(owner, _to);
    }
}

abstract contract IssuerHelper is OwnerHelper {
    mapping(address => bool) public issuers;

    event AddIssuer(address indexed _issuer);
    event DelIssuer(address indexed _issuer);

    modifier onlyIssuer() {
        require(isIssuer(msg.sender) == true);
        _;
    }

    constructor() {
        issuers[msg.sender] = true;
    }

    function isIssuer(address _addr) public view returns (bool) {
        return issuers[_addr];
    }

    // Issuer 추가
    function addIssuer(address _addr) public onlyOwner returns (bool) {
        require(issuers[_addr] == false);
        issuers[_addr] = true;
        emit AddIssuer(_addr);
        return true;
    }

    // Issuer 삭제
    function delIssuer(address _addr) public onlyOwner returns (bool) {
        require(issuers[_addr] == true);
        issuers[_addr] = false;
        emit DelIssuer(_addr);
        return true;
    }
}

contract CredentialBox is IssuerHelper {
    uint256 private idCount;
    mapping(uint8 => string) private alumniEnum;
    mapping(uint8 => string) private statusEnum;

    struct Credential {
        uint256 id; // idCount(index)
        address issuer; // 발급자
        uint8 alumniType; // 졸업증명서 타입
        uint8 statusType;
        string value; // 크리덴셜에 포함되어야하는 암호화된 정보
        uint256 createDate;
    }

    mapping(address => Credential) private credentials;

    constructor() {
        idCount = 1;
        alumniEnum[0] = "SEB";
        alumniEnum[1] = "BEB";
        alumniEnum[2] = "AIB";
    }

    // 발급자(issuer)는 어떠한 주체(_alumniAddress)에게 크리덴셜(Credential)을 발행(claim)
    function claimCredential(
        address _alumniAddress,
        uint8 _alumniType,
        string calldata _value
    ) public onlyIssuer returns (bool) {
        Credential storage credential = credentials[_alumniAddress];
        require(credential.id == 0);
        credential.id = idCount;
        credential.issuer = msg.sender;
        credential.alumniType = _alumniType;
        credential.statusType = 0;
        credential.value = _value;
        credential.createDate = block.timestamp; // 크리덴셜을 클레임한 시간을 크리덴셜에 저장

        idCount += 1;

        return true;
    }
    // 주체(_alumniAddress)를 통하여 발행(claim)한 크리덴셜(Credential)을 확인
    function getCredential(address _alumniAddress)
        public
        view
        returns (Credential memory)
    {
        return credentials[_alumniAddress];
    }

    // Alumni Type 추가 함수
    function addAlumniType(uint8 _type, string calldata _value)
        public
        onlyIssuer
        returns (bool)
    {
        require(bytes(alumniEnum[_type]).length == 0); // bytes로 변환하여 길이로 null인지 검사
        alumniEnum[_type] = _value;
        return true;
    }

    function getAlumniType(uint8 _type) public view returns (string memory) {
        return alumniEnum[_type];
    }

    function addStatusType(uint8 _type, string calldata _value)
        public
        onlyIssuer
        returns (bool)
    {
        require(bytes(statusEnum[_type]).length == 0);
        statusEnum[_type] = _value;
        return true;
    }

    function getStatusType(uint8 _type) public view returns (string memory) {
        return statusEnum[_type];
    }

    // 특정 사용자의 상태를 변경 - 크리덴셜 내부에 존재하는 statusType의 값을 가져와 변경
    function changeStatus(address _alumni, uint8 _type)
        public
        onlyIssuer
        returns (bool)
    {
        require(credentials[_alumni].id != 0);
        require(bytes(statusEnum[_type]).length != 0);
        credentials[_alumni].statusType = _type;
        return true;
    }
}