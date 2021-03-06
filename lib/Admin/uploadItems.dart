import 'dart:io';
import 'package:aqibecomappuseingfirebase/Admin/adminLogin.dart';
import 'package:aqibecomappuseingfirebase/Admin/adminShiftOrders.dart';
import 'package:aqibecomappuseingfirebase/Widgets/loadingWidget.dart';
import 'package:aqibecomappuseingfirebase/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}





class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;

  TextEditingController _desctextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _shorttextEditingController = TextEditingController();

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;


  @override
  Widget build(BuildContext context) {
    return file == null ? dispayAdminHomeScreen() : displayAdminUploadScreen();
  }

  dispayAdminHomeScreen(){
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white,),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),

        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text('LogOut' , style: TextStyle(color: Colors.pink , fontWeight: FontWeight.bold , fontSize: 16.0),),),
        ],
        ),
      body: getAdminHomeScreenBody(),
      );
  }
  getAdminHomeScreenBody(){
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(colors: [Colors.pink , Colors.lightGreenAccent],
          begin: FractionalOffset(0.0,0.0),
          end: FractionalOffset(1.0,0.0),
          stops: [0.0 , 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shop_two, color: Colors.white,size: 200.0,),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
              child: Text('Add New Items' , style: TextStyle(fontSize: 20.0, color: Colors.white),),
              color: Colors.green,
              onPressed: (){
                takeImage(context);
              },
            ),
            )
          ],
        ),
      ),
    );
  }
  takeImage(mContext) async{
    return showDialog(
      context: mContext,
        builder: (con)  {
        return SimpleDialog(
          title: Text('Item Images' , style: TextStyle(color: Colors.green , fontWeight: FontWeight.bold),),
            children:  [
              SimpleDialogOption(
                  child: Text('Capture With Cammera' , style: TextStyle(color: Colors.green),),
                      // onPressed: capturePhotowithCamera(),
        ),
              SimpleDialogOption(
                child: Text('Select From gallery' , style: TextStyle(color: Colors.green),),
                onPressed: PickPhotoFromGallery(),
        ),
          SimpleDialogOption(
            child: Text('Cancel' , style: TextStyle(color: Colors.green),),
              onPressed: (){
              Navigator.pop(context);
        },
        ),
          ],
        );
      }
    );

  }

  capturePhotowithCamera() async{

    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera , maxHeight: 680.0 , maxWidth: 970.0);

    setState(() {

      file = imageFile;

    });
  }

  PickPhotoFromGallery() async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {

      file = imageFile;

    });
  }


  displayAdminUploadScreen(){
    return Scaffold(
      appBar: AppBar(
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back , color: Colors.white,),
          onPressed: (){
            clearFromInform;
          },
        ),
        title: Text(
          'New Product' , style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0
        ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: uploading ? null :  () => uploadImageAndSaveItemInfo(),
              child: Text('Add' , style: TextStyle( color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16.0
              ),
              ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          uploading ? circularProgress() : Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        file
                      ),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
            ),
          ),

          Padding(
              padding: EdgeInsets.only(top: 12.0),
          ),

          ListTile(
            leading: Icon(Icons.perm_device_information , color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.deepPurpleAccent
                ),
                controller: _shorttextEditingController,
                decoration: InputDecoration(
                  hintText: 'Short Info',
                  hintStyle: TextStyle(
                    color: Colors.deepPurpleAccent
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),


          ListTile(
            leading: Icon(Icons.perm_device_information , color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                    color: Colors.deepPurpleAccent
                ),
                controller: _titletextEditingController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),

          ListTile(
            leading: Icon(Icons.perm_device_information , color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                    color: Colors.deepPurpleAccent
                ),
                controller: _desctextEditingController,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),

          ListTile(
            leading: Icon(Icons.perm_device_information , color: Colors.pink,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.deepPurpleAccent
                ),
                controller: _pricetextEditingController,
                decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent
                    ),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearFromInform(){

    setState(() {
      file = null;
      _desctextEditingController.clear();
      _pricetextEditingController.clear();
      _titletextEditingController.clear();
      _shorttextEditingController.clear();


    });

  }


  uploadImageAndSaveItemInfo() async{
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveImageIfo(imageDownloadUrl);

  }

  Future<String> uploadItemImage(mFileImage) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child('Items');
    StorageUploadTask uploadTask = storageReference.child('product_$productId.jpg').putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveImageIfo(String downloadUrl){

    final itemsRef = Firestore.instance.collection('items');
    itemsRef.document(productId).setData({
      'shortInfo': _shorttextEditingController.text.trim(),
      'longDescription': _desctextEditingController.text.trim(),
      'price': int.parse(_pricetextEditingController.text),
      'publishedDate': DateTime.now(),
      'status': "Availible",
      'thumbnailUrl': downloadUrl,
      'title': _titletextEditingController.text.trim(),

    });

    setState(() {

      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _desctextEditingController.clear();
      _pricetextEditingController.clear();
      _shorttextEditingController.clear();
      _titletextEditingController.clear();

    });

  }
}


