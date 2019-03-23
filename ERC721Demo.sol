pragma solidity ^0.4.20;
import "./ERC721.sol";
import "./ERC165.sol";
import "./SupportsInterface.sol";
import "./ERC721Metadata.sol";
import "./ERC721Enumerable.sol";




contract ERC721Demo is ERC721 ,SupportsInterface,ERC721Metadata,ERC721Enumerable{
   // using SafeMath for uint256;
   // using AddressUtils for address;
    
    /**
    * @dev Magic value of a smart contract that can recieve NFT.
    * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
    */
    bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
    
    
   string  public tokenName="Result";
   string  public tokenSymbol = "RST";
   uint256  public totalTokens = 100;
   uint256  public tokenId = 1077;
   mapping(address => uint) public balances;
   mapping(uint256 => address)  tokenOwners;
   mapping(uint256 => address)  approved;
   mapping(uint256 => bool) public tokenExists;
   mapping(address => mapping (address => uint256)) private allowed;
   mapping(address => mapping( uint256=> uint256)) private ownerTokens;
   // Mapping from owner address to operator address to approval
  mapping (address => mapping (address => bool)) private operatorApprovals;
   
   
   mapping(uint256 => string) tokenLinks;
   
   uint256 [] token;

   
    function ERC721Demo(string _name,string symbol,uint initialAmount) public {
    //表明使用了ERC721接口，就是当你的合约使用了什么接口的时候，都可以通过这个方法将得到的interface ID写到数组中进行记录，这样检测也就只用查询数组即可
      supportedInterfaces[0x80ac58cd] = true; // ERC721
      supportedInterfaces[0x5b5e139f] = true; //ERC721Metadata
      supportedInterfaces[0x780e9d63] = true; //ERC721Metadata
      
      tokenName =_name;
      tokenSymbol =symbol;
      totalTokens = initialAmount;
      balances[msg.sender] = initialAmount;
      tokenExists[1077]=true;
      tokenOwners[1077] = msg.sender;
      token.push(tokenId);
    }
    
    function totalSupply() external view returns (uint256){
        return totalTokens;
    }
   
   function tokenByIndex(uint256 _index) external view returns (uint256) {
       return token[_index];
   }
   
   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
       return ownerTokens[_owner][_index];
   }
   
   function name() external view returns (string _name){
       return tokenName;
   }
   
   function symbol() external view returns (string _symbol){
        return tokenSymbol;
   }
   
   function tokenURI(uint256 _tokenId) external view returns (string){
       return tokenLinks[_tokenId];
   }
   
   function balanceOf(address _owner) external view returns (uint256){
       return balances[_owner];
   }
   
   function ownerOf(uint256 _tokenId) external view returns (address){
       require(tokenExists[_tokenId]);
       return tokenOwners[_tokenId];
   }
   function _approve(address _to, uint256 _tokenId) public payable {
       require(msg.sender == this.ownerOf(_tokenId));
       require(msg.sender != _to);
       allowed[msg.sender][_to] = _tokenId;
       Approval(msg.sender, _to, _tokenId);
   }
   
    
   function takeOwnership(uint256 _tokenId) external {
       require(tokenExists[_tokenId]);
       address oldOwner = this.ownerOf(_tokenId);
       address newOwner = msg.sender;
       require(newOwner != oldOwner);
       require(allowed[oldOwner][newOwner] == _tokenId);
       balances[oldOwner] -= 1;
       tokenOwners[_tokenId] = newOwner;
       balances[oldOwner] += 1;
       Transfer(oldOwner, newOwner, _tokenId);
   }

 
   function tokenMetadata(uint256 _tokenId) external view returns (string memory infoUrl){
       return tokenLinks[_tokenId];
   }


   function transferFrom(address _from,address _to, uint256 _tokenId) external payable {
       _transferFrom(_to,_tokenId);
   }
   
   function _transferFrom(address _to, uint256 _tokenId) public payable {
       address currentOwner = msg.sender;
       address newOwner = _to;
       require(tokenExists[_tokenId]);
       require(currentOwner == this.ownerOf(_tokenId));
       require(currentOwner != newOwner);
       require(newOwner != address(0));
       //removeFromTokenList(_tokenId);
       balances[currentOwner] -= 1;
       tokenOwners[_tokenId] = newOwner;
       balances[newOwner] += 1;
       Transfer(currentOwner, newOwner, _tokenId);
   }
   
   function safeTransferFrom(address _from,address _to, uint256 _tokenId) external payable{
       _safeTransferFrom(_from, _to, _tokenId);
   }
   
   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable{}

   
   function _safeTransferFrom(address _from,address _to,uint256 _tokenId)public payable{
        address tokenOwner = tokenOwners[_tokenId];
        require(tokenOwner == _from);
        require(_to != address(0));
    
        _transferFrom(_to, _tokenId);
        //即如果transfer的_to地址是一个合约地址的话,该transfer将会失败，因为在ERC721TokenReceiver接口中，
        //onERC721Received函数的调用什么都没有返回，默认为null
        //这就是对transfer的一种限制，所以为safe
    
        /*if (_to.isContract()) {//在library AddressUtils中实现
          bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
          require(retval == MAGIC_ON_ERC721_RECEIVED);//该require将revert这个transfer transaction
        }*/
     
      }
      
  function approve(address _approved, uint256 _tokenId) external payable {
      _approve(_approved,_tokenId);
  }
  
  function _setApprovalForAll(address _operator, bool _approved) public {
        
    }
    
    function setApprovalForAll(address _operator, bool _approved) external {
        _setApprovalForAll(_operator,_approved);
        ApprovalForAll(msg.sender, _operator, _approved);
    }
    
    function _getApproved(uint256 _tokenId) public view returns (address){
        return approved[_tokenId];
    }
    
    function getApproved(uint256 _tokenId) external view returns (address){
        _getApproved(_tokenId);
    }
    
    function _isApprovedForAll(address _owner, address _operator) internal view returns(bool) {
        return operatorApprovals[_owner][_operator];
    }
    
    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
         _isApprovedForAll(_owner,_operator);   
    }
   
   
}

