import 'dart:async';

import 'package:aqibecomappuseingfirebase/Authentication/authenication.dart';
import 'package:aqibecomappuseingfirebase/Config/config.dart';
import 'package:aqibecomappuseingfirebase/Store/storehome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => CartItemCounter(),
        ),
        ChangeNotifierProvider(
          create: (c) => CartItemCounter(),
        ),

        ChangeNotifierProvider(
          create: (c) => AddressChanger(),
        ),

        ChangeNotifierProvider(
          create: (c) => TotalAmount(),
        ),

        ChangeNotifierProvider(
          create: (c) => CartItemCounter(),
        ),
      ],

      child: MaterialApp(
          title: 'e-Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    displaySpleash();
  }

  displaySpleash(){
    Timer(Duration(seconds: 5), () async {

      if( await  EcommerceApp.auth.currentUser() != null){
        Route route = MaterialPageRoute(builder: (_) => StoreHome(),);
        Navigator.push(context, route);
      }else{
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen(),);
        Navigator.push(context, route);
      }

    }) ;
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.pink , Colors.lightGreenAccent],
            begin: FractionalOffset(0.0,0.0),
            end: FractionalOffset(1.0,0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/welcome.png'),
              SizedBox(
                height: 20.0,
              ),
              Text('World a Largest Online Shop ' , style:  TextStyle(color: Colors.white),),
            ],
          ),
        ),
      )
    );
  }
}
