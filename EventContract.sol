// SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

contract EventOrganisation{

    struct Event{
        address organiser;
        string name;
        uint date ;
        uint price;
        uint ticketsCount;
        uint ticketsRemaining;
    }
    mapping(uint => Event) public eventsList;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
    function createEvent(string memory name , uint date , uint price , uint ticketsCount) public{
        // Event creation time should be greater than current time
        require(date > block.timestamp , "Invalid time for event");
        // You must tickets to create Event
        require(ticketsCount > 0 , "You don't have enough tickets");
        eventsList[nextId] = Event(msg.sender , name , date , price , ticketsCount , ticketsCount);
        nextId++;
    }

    function buyTickets(uint id , uint Quantity) public payable{
        require(eventsList[id].date != 0 , "Event does not exist");
        require(block.timestamp < eventsList[id].date , "Event no longer exists");
        Event storage _event = eventsList[id];
        require(msg.value ==(_event.price * Quantity) , "Less payment than required ");
        require(_event.ticketsRemaining > 0 ,"No more tickets left");
        _event.ticketsRemaining -= Quantity;
        tickets[msg.sender][id]+=Quantity;
    }
    function transferTicket(uint _id , uint _quantity , address _to) public {
        require(eventsList[_id].date != 0 , "Event does not exist");
        require(block.timestamp < eventsList[_id].date , "Event no longer exists");
        require(tickets[msg.sender][_id] >= _quantity , "You don't have enough tickets to transfer");
        tickets[msg.sender][_id] -= _quantity;
        tickets[_to][_id]+= _quantity;

    }
}
