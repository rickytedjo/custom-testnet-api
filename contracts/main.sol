// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract ProjectToken is ERC20 {
    using Strings for uint256;

    constructor() ERC20("ProjectToken", "PTKN") {}

    struct TokenDetail {
        string tokenId;
        string idProjek;
        string idUser;
        int256 nilai;  // Changed to int256
    }

    struct Transaksi {
        string idUser;
        string namaUser;
        string idProjek;
        string judulProjek;
        string ownerProjek;
        int256 jumlahToken;  // Changed to int256
        int256 totalNominal;  // Changed to int256
    }
    struct Agreement {
        string idProjek;
        string idUser;
        string namaProyek;
        string namaPetugas;
        string alamatPetugas;
        string namaPemilikProyek;
        string nik;
        string noHp;
        string alamat;
        string signature;
        string tandaTangan;
        int256 nominalDisetujui;  // Changed to int256
        uint256 createdAt;
    }

    mapping(uint256 => Agreement) public agreements;
    uint256 public agreementCount;

    event AgreementCreated(
        string idProjek,
        string idUser,
        string namaProyek,
        string namaPetugas,
        string alamatPetugas,
        string namaPemilikProyek,
        string nik,
        string noHp,
        string alamat,
        string signature,
        string tandaTangan,
        int256 nominalDisetujui,
        uint256 createdAt
    );

    mapping(string => TokenDetail) public tokenDetails;

    uint256 private tokenIdCounter;

    string[] public allTokenIds;

    event TokenCreated(
        string indexed tokenId,
        string idProjek,
        string idUser,
        int256 nilai 
    );
    event TokenNominalReset(string indexed tokenId);

    Transaksi[] public transaksiList;

    function generateUniqueId() private returns (string memory) {
        tokenIdCounter += 1;
        uint256 counter = tokenIdCounter;
        return
            string(
                abi.encodePacked(
                    "TKN-",
                    block.timestamp.toString(),
                    "-",
                    counter.toString()
                )
            );
    }

    function createToken(
        string memory idProjek,
        string memory idUser,
        int256 nilai
    ) public {
        string memory tokenId = generateUniqueId();

        _mint(msg.sender, uint256(nilai >= 0 ? nilai : -nilai));

        tokenDetails[tokenId] = TokenDetail(tokenId, idProjek, idUser, nilai);
        allTokenIds.push(tokenId);

        emit TokenCreated(tokenId, idProjek, idUser, nilai);
    }
    
    function getAllTokens() public view returns (TokenDetail[] memory) {
        TokenDetail[] memory tokens = new TokenDetail[](allTokenIds.length);

        for (uint256 i = 0; i < allTokenIds.length; i++) {
            tokens[i] = tokenDetails[allTokenIds[i]];
        }

        return tokens;
    }

    function getTokenById(
        string memory tokenId
    ) public view returns (TokenDetail memory) {
        require(
            bytes(tokenDetails[tokenId].tokenId).length > 0,
            "Project Token not found"
        );
        return tokenDetails[tokenId];
    }

    function getTokenByProjectId(
        string memory idProjek
    ) public view returns (TokenDetail[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < allTokenIds.length; i++) {
            if (
                keccak256(bytes(tokenDetails[allTokenIds[i]].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                count++;
            }
        }

        TokenDetail[] memory projekTokens = new TokenDetail[](count);

        uint256 index = 0;
        for (uint256 i = 0; i < allTokenIds.length; i++) {
            if (
                keccak256(bytes(tokenDetails[allTokenIds[i]].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                projekTokens[index] = tokenDetails[allTokenIds[i]];
                index++;
            }
        }

        return projekTokens;
    }

    function getTokenByUserAndProject(
        string memory idUser,
        string memory idProjek
    ) public view returns (TokenDetail[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < allTokenIds.length; i++) {
            if (
                keccak256(bytes(tokenDetails[allTokenIds[i]].idUser)) ==
                keccak256(bytes(idUser)) &&
                keccak256(bytes(tokenDetails[allTokenIds[i]].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                count++;
            }
        }

        TokenDetail[] memory filteredTokens = new TokenDetail[](count);

        uint256 index = 0;
        for (uint256 i = 0; i < allTokenIds.length; i++) {
            if (
                keccak256(bytes(tokenDetails[allTokenIds[i]].idUser)) ==
                keccak256(bytes(idUser)) &&
                keccak256(bytes(tokenDetails[allTokenIds[i]].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                filteredTokens[index] = tokenDetails[allTokenIds[i]];
                index++;
            }
        }

        return filteredTokens;
    }

    function getTotalTokens() public view returns (uint256) {
        return allTokenIds.length;
    }

    function resetTokenNominal(string memory tokenId) public {
        require(
            bytes(tokenDetails[tokenId].tokenId).length > 0,
            "Project Token not found"
        );

        int256 currentValue = tokenDetails[tokenId].nilai;
        tokenDetails[tokenId].nilai = 0;

        _burn(msg.sender, uint256(currentValue >= 0 ? currentValue : -currentValue));

        emit TokenNominalReset(tokenId);
    }

    function addTransaction(
        string memory idUser,
        string memory namaUser,
        string memory idProjek,
        string memory judulProjek,
        string memory ownerProjek,
        int256 jumlahToken,
        int256 totalNominal
    ) public {
        transaksiList.push(
            Transaksi({
                idUser: idUser,
                namaUser: namaUser,
                idProjek: idProjek,
                judulProjek: judulProjek,
                ownerProjek: ownerProjek,
                jumlahToken: jumlahToken,
                totalNominal: totalNominal
            })
        );
    }

    function getAllTransaction() public view returns (Transaksi[] memory) {
        return transaksiList;
    }

    function getTransactionByUserId(
        string memory idUser
    ) public view returns (Transaksi[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < transaksiList.length; i++) {
            if (
                keccak256(bytes(transaksiList[i].idUser)) ==
                keccak256(bytes(idUser))
            ) {
                count++;
            }
        }

        Transaksi[] memory userTransactions = new Transaksi[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < transaksiList.length; i++) {
            if (
                keccak256(bytes(transaksiList[i].idUser)) ==
                keccak256(bytes(idUser))
            ) {
                userTransactions[index] = transaksiList[i];
                index++;
            }
        }

        return userTransactions;
    }

    function getTransactionByProjectId(
        string memory idProjek
    ) public view returns (Transaksi[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < transaksiList.length; i++) {
            if (
                keccak256(bytes(transaksiList[i].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                count++;
            }
        }

        Transaksi[] memory projectTransactions = new Transaksi[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < transaksiList.length; i++) {
            if (
                keccak256(bytes(transaksiList[i].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                projectTransactions[index] = transaksiList[i];
                index++;
            }
        }

        return projectTransactions;
    }

    function createAgreementLetter(
        string memory _idProjek,
        string memory _idUser,
        string memory _namaProyek,
        string memory _namaPetugas,
        string memory _alamatPetugas,
        string memory _namaPemilikProyek,
        string memory _nik,
        string memory _noHp,
        string memory _alamat,
        string memory _signature,
        string memory _tandaTangan,
        int256 _nominalDisetujui
    ) public {
        agreementCount++;

        agreements[agreementCount] = Agreement({
            idProjek: _idProjek,
            idUser: _idUser,
            namaProyek: _namaProyek,
            namaPetugas: _namaPetugas,
            alamatPetugas: _alamatPetugas,
            namaPemilikProyek: _namaPemilikProyek,
            nik: _nik,
            noHp: _noHp,
            alamat: _alamat,
            signature: _signature,
            tandaTangan: _tandaTangan,
            nominalDisetujui: _nominalDisetujui,
            createdAt: block.timestamp
        });

        emit AgreementCreated(
            _idProjek,
            _idUser,
            _namaProyek,
            _namaPetugas,
            _alamatPetugas,
            _namaPemilikProyek,
            _nik,
            _noHp,
            _alamat,
            _signature,
            _tandaTangan,
            _nominalDisetujui,
            block.timestamp
        );
    }

    function getAllAgreement() public view returns (Agreement[] memory) {
        Agreement[] memory allAgreements = new Agreement[](agreementCount);
        for (uint256 i = 1; i <= agreementCount; i++) {
            allAgreements[i - 1] = agreements[i];
        }
        return allAgreements;
    }

    function getAgreementByProjectId(
        string memory idProjek
    ) public view returns (Agreement[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i <= agreementCount; i++) {
            if (
                keccak256(bytes(agreements[i].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                count++;
            }
        }

        Agreement[] memory projectAgreements = new Agreement[](count);
        uint256 index = 0;
        for (uint256 i = 1; i <= agreementCount; i++) {
            if (
                keccak256(bytes(agreements[i].idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                projectAgreements[index] = agreements[i];
                index++;
            }
        }

        return projectAgreements;
    }

    function getTotalNominalToken(
        string memory idUser,
        string memory idProjek
    ) public view returns (int256) {  // Changed to int256
        int256 totalNominal = 0;  // Changed to int256

        for (uint256 i = 0; i < allTokenIds.length; i++) {
            TokenDetail memory tokenDetail = tokenDetails[allTokenIds[i]];
            if (
                keccak256(bytes(tokenDetail.idUser)) ==
                keccak256(bytes(idUser)) &&
                keccak256(bytes(tokenDetail.idProjek)) ==
                keccak256(bytes(idProjek))
            ) {
                totalNominal += tokenDetail.nilai;
            }
        }

        return totalNominal;
    }
}