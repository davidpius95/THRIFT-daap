pragma solidity 0.8.1;
contract mappingS{
    struct Ajo{
        address[] members;
        uint minimum_amount;
        uint maxMembers;
        address owner;
        mapping(address=>uint) amountDepo;
        mapping(address=>mapping(address=>uint)) memberAllocations;
        bool open;
        mapping(address=>bool) aMember;
    }
    uint id;
    mapping(uint=>Ajo) public Ajos;
    function createAjo(uint maxMember,uint _minimum_amount) public {
        Ajo storage a=Ajos[id];
        a.minimum_amount=_minimum_amount;
        a.owner=msg.sender;
        a.open=true;
        a.maxMembers=maxMember;
        id++;
    }   
    function joinAjo(uint _id) public payable{
         require(_id<id,"AJO doesn't exist");
        Ajo storage a=Ajos[_id];
        require(a.open==true,"sorry my guy, not open");
        require(a.members.length<a.maxMembers,"max no of members reached");
        require(msg.value>=a.minimum_amount,'you must deposit the min amount or greater ');
        require(a.aMember[msg.sender]==false,"OLE");
        a.members.push(msg.sender);
        a.amountDepo[msg.sender]+=msg.value;
        a.aMember[msg.sender]=true;
    }
    function giveMyMoney(address collector,uint howMuch,uint ajoID) public {
        require(ajoID<id,"AJO doesn't exist");
        Ajo storage a=Ajos[ajoID];
        require(a.aMember[msg.sender]==true && a.aMember[collector]==true,"the guy no dey here");
        require(a.amountDepo[msg.sender]>=howMuch,"OLE");
        a.amountDepo[msg.sender]-=howMuch;
        a.amountDepo[collector]+=howMuch;
    }
    function withdrawMyMoney(uint ajoID) public returns(uint) {
        require(ajoID<id,"AJO doesn't exist");
        Ajo storage a=Ajos[ajoID];
        require(a.aMember[msg.sender]==true,"nope");
        require(a.amountDepo[msg.sender]>0,"dry pocket");
        uint amountToWithdraw=a.amountDepo[msg.sender];
        a.amountDepo[msg.sender]=0;
        payable(msg.sender).transfer(amountToWithdraw);
       /** for(uint k;k<a.members.length;k++){
            if(a.members[k]==msg.sender){
            delete a.members[k];
            }
            */
    }
}
