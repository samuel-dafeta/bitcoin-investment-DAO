;; title: Bitcoin Investment DAO
;; summary: A decentralized autonomous organization for collective Bitcoin investment and yield generation.
;; description: This smart contract implements a DAO that allows members to stake tokens, create and vote on proposals, and execute approved proposals for collective Bitcoin investment. The contract includes functions for staking and unstaking tokens, creating and voting on proposals, and executing proposals based on the voting results. It also provides read-only functions to retrieve information about members, proposals, and the DAO itself.

;; Constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u101))
(define-constant ERR-PROPOSAL-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-VOTED (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-INSUFFICIENT-BALANCE (err u105))
(define-constant ERR-PROPOSAL-NOT-ACTIVE (err u106))
(define-constant ERR-INVALID-STATUS (err u107))