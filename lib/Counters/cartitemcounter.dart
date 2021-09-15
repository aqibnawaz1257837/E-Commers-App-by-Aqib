import 'package:flutter/foundation.dart';
import 'package:aqibecomappuseingfirebase/Config/config.dart';

class CartItemCounter extends ChangeNotifier{

  int _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;
  int get count => _counter;


  Future<void> displayReuslt() async{
    int _counter = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1;


    await Future.delayed(Duration (milliseconds:  100), (){
      notifyListeners();
    });
  }

}