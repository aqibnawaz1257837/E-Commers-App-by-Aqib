import 'dart:io';
import 'package:aqibecomappuseingfirebase/Widgets/customTextField.dart';
import 'package:aqibecomappuseingfirebase/DialogBox/errorDialog.dart';
import 'package:aqibecomappuseingfirebase/DialogBox/loadingDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:aqibecomappuseingfirebase/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{

  final TextEditingController _nameTextEditingController  = TextEditingController();
  final TextEditingController _emailTextEditingController  = TextEditingController();
  final TextEditingController _passwordTextEditingController  = TextEditingController();
  final TextEditingController _cpasswordTextEditingController  = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;


  @override
  Widget build(BuildContext context) {
    double _ScreenWidth = MediaQuery.of(context).size.width, _Screenheight= MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize:  MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () => _SelectAndPickImage(),
                child: CircleAvatar(
                  radius: _ScreenWidth * 0.15,
                  backgroundColor: Colors.white,
                  backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                  child: _imageFile == null ? Icon(Icons.add_photo_alternate , size:  _ScreenWidth * 0.15, color: Colors.grey,) : null,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formkey,
                child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordTextEditingController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObsecure: true,
                  ),
                ],
              ),
              ),
              RaisedButton
                (onPressed: () {
                  uploadAndSaveImage();
              },
                color: Colors.pink,
                child: Text('Sign Up' , style: TextStyle(color: Colors.white),),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 4.0,
                width: _ScreenWidth * 0.8,
                color: Colors.pink,
              ),
              SizedBox(
                height: 15.0,
              ),

            ],
          ),
        ),
      ),
    );
  }


  Future<void>  _SelectAndPickImage() async {
   _imageFile =  await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async{
    if (_imageFile == null){
      showDialog(context: context, builder: (c){
        return ErrorAlertDialog( message: 'Plaese Select the Image File !' ,);
      });
    }else{
      _passwordTextEditingController.text == _cpasswordTextEditingController.text

          ?
          _emailTextEditingController.text.isNotEmpty &&
              _passwordTextEditingController.text.isNotEmpty &&
              _cpasswordTextEditingController.text.isNotEmpty &&
              _nameTextEditingController.text.isNotEmpty

              ? uploadToStorage()
              : displayDialoag('Plase complete the form')
          : displayDialoag('Password do not match, ');
    }

  }

  displayDialoag(String msg){
    showDialog(
      context: context,
      builder: (c){
        return ErrorAlertDialog(message: msg,);
      }
    );
  }

  uploadToStorage() async {
    showDialog(
      context: context,
      builder: (c){
        return LoadingAlertDialog(message: 'Registering Please Wait .....',);
      }
    );

    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();


    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    await taskSnapshot.ref.getDownloadURL().then((urlImage){
      userImageUrl = urlImage;

      _registraterUser();
    });

  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registraterUser() async{
    FirebaseUser firebaseUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),
            );
          });

    });


    if(firebaseUser != null){
      saveUserInfoToFireStore(firebaseUser).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }

  }

  Future saveUserInfoToFireStore( FirebaseUser fuser) async{
    Firestore.instance.collection('Users').document(fuser.uid).setData(
      {
        'uid': fuser.uid,
        'email': fuser.email,
        'name': _nameTextEditingController.text.trim(),
        'url': userImageUrl,
        EcommerceApp.userCartList: ["garbageValue"],

      }
    );
    
    await EcommerceApp.sharedPreferences.setString('uid', fuser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fuser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);

  }

}

