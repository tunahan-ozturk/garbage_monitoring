// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Lottery{
    address public owner;       // kontrat yaratıcısının adresi
    address payable[] public players;   // oyuncuların tutulacağı players adında bir array, ödemeler alınacağı için payable olarak işaretledik
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;  // piyango geçmişini tutmak için mapping kullanıyoruz
    constructor() {
        owner = msg.sender;   // kontratın yaratıcısının adresini ilk olarak belirliyoruz 
        lotteryId = 1;
    }

    function getWinnerByLottery(uint lottery) public view returns(address payable){
        return lotteryHistory[lottery];
    }

    function getBalance() public  view returns (uint){ // sadece görüntülenebilir bir fonksiyon oluşturuyoruz
        return address(this).balance;     // adresin cüzdanındaki ether miktarını döndürür
    }

    function getPlayers() public view returns(address payable[] memory) { // oyuncuların gösterilmesine yarayan fonksiyon
        return players;
    }


    function enter() public payable {           // piyangoya katılımı gerçekleştirmesi için bir fonksiyon yaratıyoruz
        require(msg.value > .01 ether);         // çekilişe katılmak için belirlediğim şart
        players.push(payable(msg.sender));      // katılacak oyuncuların adreslerini players arrayine ekliyoruz
    }

    function getRandomNumber() public view returns(uint){ // rastgele sayı elde etme fonksiyonu
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));  // owner ve timestamp kullanarak adresi ve zamanı öğrendik,sonrasında bu verileri abi ve keccak256 kullanarak okunabilir hale dönüştürdük
    }

    function pickWinner() public onlyOwner{
        uint index = getRandomNumber() % players.length; // rastgele seçim yapılmasını sağlayan satır, % kullanmamızın sebebi listelerde 0'dan başlaması
        players[index].transfer(address(this).balance); // kazanana miktarı aktardığımız satır

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        

        // sıfırlayıp tekrardan bir oluşum yaratmak için
        players = new address payable[](0);

        
    }

    modifier onlyOwner() {  // modifier sayesinde yukarıdaki kazananın seçildiği fonksiyona sadece kontratı yaratan kişinin erişmesini sağlayan bir kod bloğu yarattık
        require(msg.sender == owner); 
        _;
    }
}
