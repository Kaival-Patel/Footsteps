import 'dart:math';
class UCodeGenerator {
  String ucode(String name,String uid){
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random(); 
    var rNum = min + randomizer.nextInt(max - min);
     //pass your random number through
    if(name.length>4){   
      print(rNum);
      return name.substring(0,4).toUpperCase() + rNum.toString();
    }
    else{
      return uid.substring(0,4).toUpperCase() + rNum.toString();
    }
    
  }
}
