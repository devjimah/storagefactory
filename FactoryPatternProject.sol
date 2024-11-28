// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// Basic storage contract to save and retrieve a favorite number
contract SimpleStorage {
    // Variable to store a single number
    uint256 public favoriteNumber;
    
    // Structure to store a person's name and favorite number
    struct Person {
        uint256 favoriteNumber;
        string name;
    }
    
    // List to store multiple people
    Person[] public people;
    
    // Mapping to link names with favorite numbers
    mapping(string => uint256) public nameToFavoriteNumber;
    
    // Function to save a favorite number (can be overridden by child contracts)
    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    
    // Function to get the stored favorite number
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
    
    // Function to add a new person to the list
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Add new person to the people array
        people.push(Person(_favoriteNumber, _name));
        
        // Save the person's name and favorite number in the mapping
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// Contract to create and manage multiple SimpleStorage contracts
contract StorageFactory {
    // Array to keep track of all created SimpleStorage contracts
    SimpleStorage[] public simpleStorageArray;
    
    // Function to create a new SimpleStorage contract
    function createSimpleStorageContract() public {
        // Create a new SimpleStorage contract and add it to the array
        SimpleStorage newStorage = new SimpleStorage();
        simpleStorageArray.push(newStorage);
    }
    
    // Function to store a number in a specific SimpleStorage contract
    function sfStore(uint256 _contractIndex, uint256 _newNumber) public {
        // Get the specific SimpleStorage contract from the array
        SimpleStorage selectedStorage = simpleStorageArray[_contractIndex];
        
        // Store the number in the selected contract
        selectedStorage.store(_newNumber);
    }
    
    // Function to retrieve a number from a specific SimpleStorage contract
    function sfGet(uint256 _contractIndex) public view returns (uint256) {
        // Get the specific SimpleStorage contract from the array
        SimpleStorage selectedStorage = simpleStorageArray[_contractIndex];
        
        // Retrieve and return the stored number
        return selectedStorage.retrieve();
    }
}

// Advanced storage contract that builds upon SimpleStorage
contract AdvancedStorage is SimpleStorage {
    // Override the store function with an added validation check
    function store(uint256 _favoriteNumber) public override {
        // Ensure the number is not greater than 100
        require(_favoriteNumber <= 100, "Number must be 100 or less");
        favoriteNumber = _favoriteNumber;
    }
    
    // Additional function to count the number of people
    function getNumberOfPeople() public view returns (uint256) {
        return people.length;
    }
}

// Example showing how to handle conflicts in multiple inheritance
contract BaseA {
    // Function that will potentially conflict
    function resolveConflict() public pure virtual returns (string memory) {
        return "Result from BaseA";
    }
}

contract BaseB {
    // Another function that might conflict
    function resolveConflict() public pure virtual returns (string memory) {
        return "Result from BaseB";
    }
}

// Demonstrates resolving inheritance conflicts
contract ConflictResolver is BaseA, BaseB {
    // Explicitly choose how to resolve the conflicting function
    function resolveConflict() public pure override(BaseA, BaseB) returns (string memory) {
        // Uses the method from the last inherited contract (BaseB)
        return super.resolveConflict();
    }
}