// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract CredentialBox {
    address private issuerAddress;
    uint256 private idCount;
    mapping(uint8 => string) private alumniEnum;

    struct Credential {
        uint256 id; // idCount(index)
        address issuer; // 발급자
        uint8 alumniType; // 졸업증명서 타입
        string value; // 크리덴셜에 포함되어야하는 암호화된 정보
    }

    mapping(address => Credential) private credentials;

    constructor() {
        issuerAddress = msg.sender;
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
    ) public returns (bool) {
        require(issuerAddress == msg.sender, "Not Issuer");
        Credential storage credential = credentials[_alumniAddress];
        require(credential.id == 0);
        credential.id = idCount;
        credential.issuer = msg.sender;
        credential.alumniType = _alumniType;
        credential.value = _value;

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
}