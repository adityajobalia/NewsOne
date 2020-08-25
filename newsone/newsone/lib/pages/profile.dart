import 'dart:ffi';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:newsone/controllers/userAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget{
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String displayName = "";
  String imageURL = "";
  String email = "";
  String city = "";
  double opacity = 0.0;
  bool cityInteraction = false;
  bool isUpdatingProfile = false;

  final cityTextController = TextEditingController();

 @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      displayName = prefs.getString("displayName");
      imageURL = prefs.getString("imageUrl");
      email = prefs.getString("email");
      city = prefs.getString("city");
    });
  }


  @override
  Widget build(BuildContext context) {
    cityTextController.text = city;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),color: Color(0xFF957AFF), onPressed: (){
            Navigator.of(context).pop();
          }), 
          actions: <Widget>[
            IconButton(icon: Icon(Icons.edit,color: Color(0xFF957AFF),), onPressed: (){
              setState(() {
                opacity = 1.0;
                cityInteraction = true;
              });
            })
          ], 
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color(0xFF957AFF),
          ),
          title: Text("Profile"),
          backgroundColor: Colors.white24,
          elevation: 0.0,
      ),
      body: SafeArea(
        child: loadWidgetWhenDataAppears(context),),
    );
  }

  Widget loadWidgetWhenDataAppears(BuildContext context) {
    if (!isUpdatingProfile) {
      return createBody();
    }
    else {
      return Center(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitCubeGrid(
              color: Color(0xFF957AFF),
              size: 50.0,
            )

          ],
        ),
      );
    }
  }

  Widget createBody(){
    return Container(
           margin: EdgeInsets.only(top: 25),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(radius: 60, backgroundImage: imageURL.isNotEmpty?NetworkImage(imageURL):null),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: createName()
              ),
              Container(
                alignment: Alignment.topLeft,
                child: createEmail()
              ),
             
              SizedBox(
                height: 25,
              ),
              RichText(
              text: TextSpan(
                text: "City",               
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  color: Color(0xFF4A4A4A)
                )
            )
            ),
              TextField(
                enabled: cityInteraction,
                controller: cityTextController,
                
                decoration: InputDecoration(
                    hintText: "",
                    focusColor: Color(0xFF957AFF),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54
                      )
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF957AFF)
                      )
                    ),
                    border: new UnderlineInputBorder(
                      borderSide: BorderSide(width: MediaQuery.of(context).size.width),
                        )),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.only(left: 35.0, right: 35.0),
                child: Opacity(
                  opacity: opacity,
                  child: createButton(context),
                  ),
              )
            ],
          ),
        );
  }
  Widget createName(){
    return Container(
      padding: EdgeInsets.only(top:30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
              text: TextSpan(
                text: "Name",               
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  color: Color(0xFF4A4A4A)
                )
            )
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                text: displayName,
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  color: Color(0xFFD6D6D6)
                )
            )
            ),
          )
        ],
      ),
    );
  }

  Widget createEmail(){
    return Container(
padding: EdgeInsets.only(top:20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
              text: TextSpan(
                text: "Email",               
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                  color: Color(0xFF4A4A4A)
                )
            )
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                text: email,
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  color: Color(0xFFD6D6D6)
                )
            )
            ),
          )
        ],
      ),
    );
  }

  Widget createButton(BuildContext context){
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.height/20,
      child: new OutlineButton(
        onPressed: ()async {
          setState(() {
            isUpdatingProfile = true;
          });
          final SharedPreferences prefs = await _prefs;
          prefs.setString("city", cityTextController.text);
          await UserAuth.registerUser(prefs.getStringList("topics"), cityTextController.text);
          setState(() {
            
            cityInteraction = false;
            opacity = 0.0;
          });
          Navigator.pop(context);
      },

      child: Text("Save"),
      highlightedBorderColor: Color(0xFF957AFF),
      borderSide: BorderSide(color: Color(0xFF957AFF)),
      highlightColor: Colors.white24,
      textColor: Color(0xFF957AFF),
      textTheme: ButtonTextTheme.normal,
      highlightElevation: 10.0,
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      ),
    );
    
  }
}