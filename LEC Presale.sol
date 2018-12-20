pragma solidity ^0.4.23;

library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

contract LECToken {
    function transfer(address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);
    function totalFrozen() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
}

contract Affiliate {
    function playerFrom(string inviterCode, address sender, uint256 amount) external returns (bool);
    function showInvitationCodeOf(string _code) external view returns(address);
}

contract presell {
    using SafeMath for uint256;
    
   modifier onlyOwner {
         require(msg.sender == owner);
         _;
    }
    
    address public owner;
    LECToken public myToken;
    Affiliate public affiliate;
    uint256 public startTime;
    uint8 daysNum;
    uint256 public ratio;
    
    
    constructor() public {
         owner = msg.sender;
    }
    
    function showTotalSupply() public view returns (uint256) {
        return myToken.balanceOf(this);
    }
    
    function showBalanceOf(address _address) public view returns (uint256) {
        return myToken.balanceOf(_address);
    }
    
    /* only owner address can change Token address */
    function changeTokenAddress(address _newAddress) public onlyOwner {
        myToken = LECToken(_newAddress);
    }
    
    function changeAffiliateAddress(address _newAddress) public onlyOwner {
        affiliate = Affiliate(_newAddress);
    }
    
    function () public payable {
        require(startTime <= now && startTime + (daysNum * 1 days) > now, 'presell is over');
        require(msg.value >= 1000000000);
        myToken.transfer(msg.sender, msg.value * ratio);
    }
    
    function buyWithCode(string _code) public payable {
        require(startTime <= now && startTime + (daysNum * 1 days) > now, 'presell is over');
        require(msg.value >= 1000000000);
        myToken.transfer(msg.sender, msg.value * ratio);
        if(affiliate.showInvitationCodeOf(_code) != 0x0) {
            affiliate.playerFrom(_code, msg.sender, msg.value);
        }
    }
    
    function buy() public payable {
        require(startTime <= now && startTime + (daysNum * 1 days) > now, 'presell is over');
        require(msg.value >= 1000000000);
        myToken.transfer(msg.sender, msg.value * ratio);
    }
    
    function setStartTime(uint256 _time, uint8 _day, uint256 _ratio) public 
		onlyOwner
    {        
        startTime = _time;
        daysNum = _day;
        ratio = _ratio;
    }
    
    /* only owner address can transfer tron */
    function ownerTransfer(address sendTo, uint amount) public 
		onlyOwner
    {        
        sendTo.transfer(amount);
    }
}
