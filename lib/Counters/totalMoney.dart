import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{


  double _totalAmmount = 0;

  double get totalAmount => _totalAmmount;

  display(double no) async {
    _totalAmmount = no;


    await Future.delayed( Duration (milliseconds: 100), () {
      notifyListeners();
    });
  }

}