// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract User {
    mapping(address => mapping(address => LoanUser)) public userReceived;

    // To check who asked for a loan
    mapping(address => address[]) _askedEthList;
    mapping(address => mapping(address => AskedInfos)) internal _asked;

    address[] public sentToList;

    enum Status {
        InProgress,
        Accpeted,
        Rejected
    }

    struct AskedInfos {
        address userAskedAddress;
        uint ethToBorrow;
        Status status;
    }

    struct LoanUser {
        address userAskedAddress;
        uint ethBorrowed;
    }
}
