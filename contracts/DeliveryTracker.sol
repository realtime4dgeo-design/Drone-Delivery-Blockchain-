// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DeliveryTracker is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _deliveryId;

    struct Delivery {
        uint256 id;
        address customer;  // DID-derived address
        string ipfsHash;   // Encrypted delivery data on IPFS
        uint256 timestamp;
        bool completed;
        string eventLog;   // e.g., "delivered"
    }

    mapping(uint256 => Delivery) public deliveries;
    event DeliveryLogged(uint256 id, address customer, string ipfsHash, string eventLog);

    constructor() Ownable(msg.sender) {}

    function logDelivery(address _customer, string memory _ipfsHash, string memory _eventLog) external onlyOwner {
        _deliveryId.increment();
        uint256 newId = _deliveryId.current();
        deliveries[newId] = Delivery(newId, _customer, _ipfsHash, block.timestamp, false, _eventLog);
        emit DeliveryLogged(newId, _customer, _ipfsHash, _eventLog);
    }

    function completeDelivery(uint256 _id) external onlyOwner {
        require(deliveries[_id].id != 0, "Delivery not found");
        deliveries[_id].completed = true;
    }

    function getDelivery(uint256 _id) external view returns (Delivery memory) {
        return deliveries[_id];
    }
}

