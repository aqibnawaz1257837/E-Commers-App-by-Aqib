import 'package:aqibecomappuseingfirebase/Widgets/customAppBar.dart';
import 'package:aqibecomappuseingfirebase/Widgets/myDrawer.dart';
import 'package:aqibecomappuseingfirebase/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:aqibecomappuseingfirebase/Store/storehome.dart';


class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {


  int quantityOfItems = 1;


  @override
  Widget build(BuildContext context)
  {
    Size sxreenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
        ),
        drawer: MyDrawer(),
        body: ListView(
          children: <Widget>[
            Container(
            padding: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: Image.network(widget.itemModel.thumbnailUrl),
                    ),
                    Container(
                      color: Colors.grey[300],
                      child: SizedBox(
                        height: 1.0,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.itemModel.title , style: boldTextStyle,),
                        SizedBox(height: 10.0,),

                        Text(widget.itemModel.longDescription),
                        SizedBox(height: 10.0,),

                        Text(
                           "€ " + widget.itemModel.price.toString()),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(colors: [Colors.pink , Colors.lightGreenAccent],
                            begin: FractionalOffset(0.0,0.0),
                            end: FractionalOffset(1.0,0.0),
                            stops: [0.0 , 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width - 40.0,
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Add To Cart' , style: TextStyle(
                            color: Colors.white
                          ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
            ),
            ),
          ],
        ),
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);