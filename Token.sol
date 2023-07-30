//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve( address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyToken is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply; // keeping it 0
    uint256 public maxTotalSupply; // added to maximum limit on the total supply

    address public Owner;

    mapping(address => mapping(address => uint256)) private allow;
    mapping(address => uint256) public balance;

    modifier onlyOwner () {
        require(Owner == msg.sender, "not owner");
        _;
    } 

    constructor(string memory _name, string memory _symbol, uint256 _decimals) {
        
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = 0;
        maxTotalSupply = 1000000000000000000 ;
        Owner = msg.sender;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allow[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        //uint256 convertedAmount = amount * (10 ** decimals);
        allow[msg.sender][spender] = amount; 
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns(bool) {
        //uint256 convertedAmount = amount * (10 ** decimals);
        require(allow[sender][msg.sender] >= amount, "Not enough allowance");
        balance[sender] -= amount;
        balance[recipient] += amount;
        allow[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external override returns(bool) {
        //uint256 convertedAmount = amount * (10 ** decimals);
        require(amount < balance[msg.sender], "Insufficient balance");
        balance[msg.sender] -= amount;
        balance[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function balanceOf(address account) external view override returns(uint256) {
        return balance[account];
    }

    // function mint(address account, uint256 amount) public onlyOwner returns(uint256){
    //     require((totalSupply + amount) <= maxTotalSupply, "Here it is exceeding max supply limit");
    //     balance[account] += amount * (10 ** decimals);
    //     totalSupply += amount * (10 ** decimals);
    //     return balance[account];
    // }
    function mint(address account, uint256 amount) public onlyOwner returns(uint256){
    require((totalSupply + amount) <= maxTotalSupply, "Minting would exceed max supply limit");
    balance[account] += amount * (10 ** decimals);
    totalSupply += amount * (10 ** decimals);
    return balance[account];
}


    function burn(uint256 amount) public  returns(uint256){
        require(amount <= balance[msg.sender], "Insufficient balance");

        balance[msg.sender] -= amount * (10 ** decimals);
        totalSupply -= amount * (10 ** decimals);
        return balance[msg.sender];
    }
    
}