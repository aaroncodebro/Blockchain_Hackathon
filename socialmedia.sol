pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract SocialMedia{
   
    struct user{
               uint id;
               string name;
               string uname;
               string[] requests;
               string[] friends;
               }
   
    user[] private users;
   

    mapping (string => uint) uname_to_count;
    mapping (uint => uint) id_to_index;
    mapping (uint => uint) id_to_count;
    mapping (string => uint) uname_to_index;
    mapping (uint => string) id_to_uname;
    mapping (string => uint) uname_to_request_index;
   
    function _createuser(uint _id, string memory _name, string memory _uname, string[] memory requests, string[] memory friends) private
    {
     uint index = users.push(user(_id, _name, _uname, requests, friends))-1;
     id_to_index[_id] = index;
     uname_to_index[_uname] = index;
     uname_to_count[_uname] ++;
     id_to_uname[_id] = _uname;
     id_to_count[_id]++;
    }
   
    function _generateid () private view returns(uint)
    {
     return uint(msg.sender);
    }
   
    function _generateuser(string memory _name, string memory _uname) public
    {
     string[] memory requests;
     string[] memory friends;
     require(uname_to_count[_uname]==0, "This username is already taken, please choose another one");
     uint uid=_generateid();
     require(id_to_count[uid]==0, "You have already created an account");
     _createuser(uid, _name, _uname, requests, friends);
    }
   
    function userdetails(string memory uname) public view returns(string memory, uint)
    {
     user storage user_data = users[uname_to_index[uname]];
     return(user_data.name, uname_to_index[uname]);
    }
       
    function _sendrequest(string memory uname) public
    {
     user storage user_data = users[uname_to_index[uname]];
     string memory uname1 = id_to_uname[uint(msg.sender)];
   
     uname_to_request_index[uname1]= user_data.requests.push(uname1)-1;
    }
   
    function viewrequests() public view returns(string[] memory)
    {uint myid = uint(msg.sender);
     user storage my_data = users[id_to_index[myid]];
     return(my_data.requests);        
    }
   
    function acceptrequests(string memory uname) public      
    {
     uint myid = uint(msg.sender);                      //Current users ID
     user storage my_data = users[id_to_index[myid]];   //Current users data
     
     my_data.friends.push(uname);                       //Addition in friends
     uint index1 = uname_to_request_index[uname];
     delete my_data.requests[index1];                   //Deleting the request after acceptance
    }    
       
    function viewfriends() public view returns(string[] memory)
    {uint myid = uint(msg.sender);                      //Current users ID
     user storage my_data = users[id_to_index[myid]];   //Current users data
     return(my_data.friends);        
    }
   
}
