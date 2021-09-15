import 'package:aqibecomappuseingfirebase/Store/cart.dart';
import 'package:aqibecomappuseingfirebase/Counters/cartitemcounter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [Colors.pink , Colors.lightGreenAccent],
            begin: FractionalOffset(0.0,0.0),
            end: FractionalOffset(1.0,0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          ),
        ),

      ),
      centerTitle: true,
      title: Text('E-Shop By AQib' , style: TextStyle(fontSize: 55.0 , color: Colors.white , fontWeight: FontWeight.w600 , fontFamily: 'Signatra'),
      ),

      bottom: bottom,

      actions: [
        Stack(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.pink,
              ), onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => CartPage());
              Navigator.pushReplacement(context, route);
            },
            ),
            Positioned(child: Stack(
              children: <Widget>[
                Icon(
                  Icons.brightness_1,
                  size: 20.0,
                  color: Colors.green,
                ),
                Positioned(
                  top: 3.0,
                  bottom: 4.0,
                  left: 4.0,
                  child: Consumer<CartItemCounter>(
                    builder: (context,  counter, _){
                      return Text(
                        counter.count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      );
                    },
                  ),
                )
              ],
            ))
          ],
        ),
      ],
    );

  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
