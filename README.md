# Auction Service Contracts

gRPC service definition for a simple auction system.

## RPC Methods

### `Sell(SellRequest) returns (SellResponse)`
Creates a new auction listing.

**SellRequest**
- `item_id` (uint64, field 1): ID of the item being auctioned
- `seller_id` (uint64, field 2): ID of the seller
- `duration` (uint64, field 3): Auction duration in milliseconds

**SellResponse**
- `success` (bool, field 1): Whether the listing was created successfully

### `Bid(BidRequest) returns (BidResponse)`
Submits a bid for an existing auction listing.

**BidRequest**
- `item_id` (uint64, field 1): ID of the auctioned item
- `bidder_id` (uint64, field 2): ID of the bidder
- `amount` (uint64, field 3): Bid amount

**BidResponse**
- `success` (bool, field 1): Whether the bid was accepted successfully

### `Cancel(CancelRequest) returns (CancelResponse)`
Cancels an existing auction listing.

**CancelRequest**
- `item_id` (uint64, field 1): ID of the item to cancel
- `seller_id` (uint64, field 2): ID of the seller requesting cancellation

**CancelResponse**
- `success` (bool, field 1): Whether cancellation succeeded

### `EventStream(google.protobuf.Empty) returns (stream EventStreamResponse)`
Streams auction events (snapshot and changes) to clients.

**Request**
- `google.protobuf.Empty`

**EventStreamResponse**
Uses `oneof event`:
- `Snapshot` (field 1): Current active listings + snapshot version
- `SellEvent` (field 2): New listing created
- `BidEvent` (field 3): Highest bid updated
- `CancelEvent` (field 4): Listing cancelled
- `ExpireEvent` (field 5): Auction expired (sold or returned/settled)

## Data Types

### `Snapshot`
- `listings` (repeated AuctionListing, field 1): Active listings
- `version` (string, field 2): Snapshot version

### `AuctionListing`
- `item_id` (uint64, field 1)
- `current_bid` (uint64, field 2): Highest bid so far; 0 if none
- `expiration` (string, field 3): RFC3339 timestamp of when the listing ends

### `SellEvent`
- `item_id` (uint64, field 1)
- `seller_id` (uint64, field 2)
- `expiration` (string, field 3): RFC3339 timestamp

### `BidEvent`
- `item_id` (uint64, field 1)
- `bidder_id` (uint64, field 2)
- `amount` (uint64, field 3): New highest offer

### `CancelEvent`
- `item_id` (uint64, field 1)
- `seller_id` (uint64, field 2)
- `bidder_id` (uint64, field 3): 0 if there are no bids
- `amount` (uint64, field 4): 0 if there are no bids

### `ExpireEvent`
- `item_id` (uint64, field 1)
- `sold` (bool, field 2): Whether the item was sold
- `seller_id` (uint64, field 3)
- `bidder_id` (uint64, field 4): 0 if there are no bids
- `amount` (uint64, field 5):
  - 0 if the item expires without any bids (return to seller)
  - otherwise the final bid amount to pay to the seller

## Time Formats
- `duration`: milliseconds
- `expiration`: RFC3339 timestamp string
