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

;; Data Variables
(define-data-var dao-owner principal tx-sender)
(define-data-var total-staked uint u0)
(define-data-var proposal-count uint u0)
(define-data-var quorum-threshold uint u500) ;; 50% in basis points
(define-data-var proposal-duration uint u144) ;; ~24 hours in blocks
(define-data-var min-proposal-amount uint u1000000) ;; in uSTX

;; Data Maps
(define-map members 
    principal 
    {
        staked-amount: uint,
        last-reward-block: uint,
        rewards-claimed: uint
    }
)

(define-map proposals 
    uint 
    {
        proposer: principal,
        title: (string-ascii 100),
        description: (string-ascii 500),
        amount: uint,
        recipient: principal,
        start-block: uint,
        end-block: uint,
        yes-votes: uint,
        no-votes: uint,
        status: (string-ascii 20),
        executed: bool
    }
)

(define-map votes 
    {proposal-id: uint, voter: principal} 
    {vote: bool}
)

;; Private Functions
(define-private (is-dao-owner)
    (is-eq tx-sender (var-get dao-owner))
)

(define-private (is-member (address principal))
    (default-to false 
        (match (map-get? members address)
            member (> (get staked-amount member) u0)
            false
        )
    )
)

(define-private (get-proposal-status (proposal-id uint))
    (match (map-get? proposals proposal-id)
        proposal (get status proposal)
        "NOT_FOUND"
    )
)

(define-private (calculate-voting-power (address principal))
    (default-to u0 
        (match (map-get? members address)
            member (get staked-amount member)
            u0
        )
    )
)

;; Public Functions
(define-public (initialize (new-owner principal))
    (begin
        (asserts! (is-dao-owner) ERR-NOT-AUTHORIZED)
        (var-set dao-owner new-owner)
        (ok true)
    )
)

;; Membership Functions
(define-public (stake-tokens (amount uint))
    (let (
        (current-balance (default-to {staked-amount: u0, last-reward-block: u0, rewards-claimed: u0} 
            (map-get? members tx-sender)))
    )
    (begin
        (asserts! (>= amount u0) ERR-INVALID-AMOUNT)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        
        (map-set members tx-sender {
            staked-amount: (+ (get staked-amount current-balance) amount),
            last-reward-block: block-height,
            rewards-claimed: (get rewards-claimed current-balance)
        })
        
        (var-set total-staked (+ (var-get total-staked) amount))
        (ok true)
    ))
)

(define-public (unstake-tokens (amount uint))
    (let (
        (current-balance (default-to {staked-amount: u0, last-reward-block: u0, rewards-claimed: u0} 
            (map-get? members tx-sender)))
    )
    (begin
        (asserts! (>= (get staked-amount current-balance) amount) ERR-INSUFFICIENT-BALANCE)
        (try! (as-contract (stx-transfer? amount (as-contract tx-sender) tx-sender)))
        
        (map-set members tx-sender {
            staked-amount: (- (get staked-amount current-balance) amount),
            last-reward-block: block-height,
            rewards-claimed: (get rewards-claimed current-balance)
        })
        
        (var-set total-staked (- (var-get total-staked) amount))
        (ok true)
    ))
)