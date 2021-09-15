import 'package:aqibecomappuseingfirebase/Admin/uploadItems.dart';
import 'package:aqibecomappuseingfirebase/Authentication/authenication.dart';
import 'package:aqibecomappuseingfirebase/Widgets/customTextField.dart';
import 'package:aqibecomappuseingfirebase/DialogBox/errorDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
         title: Text('E-Shop By AQib' , style: TextStyle(fontSize: 55.0 , color: Colors.white , fontWeight: FontWeight.w600 , fontFamily: 'Signatra'),
         ),
            centerTitle: true,
           ),
           body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final TextEditingController _AdminIdTextEditingController  = TextEditingController();
  final TextEditingController _passwordTextEditingController  = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _ScreenWidth = MediaQuery.of(context).size.width, _Screenheight= MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(

        decoration: new BoxDecoration(
          gradient: new LinearGradient(colors: [Colors.pink , Colors.lightGreenAccent],
            begin: FractionalOffset(0.0,0.0),
            end: FractionalOffset(1.0,0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('images/admin.png'
                ,height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin ',style: TextStyle(
                  color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _AdminIdTextEditingController,
                    data: Icons.person,
                    hintText: 'ID',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

            RaisedButton
              (onPressed: () {
              _AdminIdTextEditingController.text.isNotEmpty &&
                  _passwordTextEditingController.text.isNotEmpty
                  ? loginAdmin() :
              showDialog(
                  context: context,
                  builder: (c){
                    return ErrorAlertDialog(message: 'please fill the fields',);
                  }
              );


            },
              color: Colors.pink,
              child: Text('Sign In' , style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _ScreenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 20.0,
            ),

            FlatButton.icon(
              icon: Icon(Icons.nature_people , color: Colors.pink,),
              label: Text('I am Not Admin' , style: TextStyle(color: Colors.pink , fontWeight: FontWeight.bold),),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  AuthenticScreen()
                )
                );
              },),
            SizedBox(
              height: 50.0,
            ),

          ],
        ),
      ),
    );
  }

  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _AdminIdTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('YOur id is not Correct.')));
        }
        else if(result.data["password"] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('YOur Password is not Correct.')));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Welcome Dear Admin. '  + result.data['name'] ),));


          setState(() {

            _AdminIdTextEditingController.text = '';
            _passwordTextEditingController.text = '';

          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }

}
