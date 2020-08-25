import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/internet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpalshScreen extends StatefulWidget {
  SpalshScreen({Key key}) : super(key: key);

  @override
  _SpalshScreenState createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckInternet.checkInternet(context, "/");
    checkUserLoggedInLocally();

    new Timer(new Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, "/auth");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Container(
            color: Color(0xFF957AFF),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //margin: EdgeInsets.only(top:150.0),
                  alignment: Alignment.center,
                  //width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height / 2,
                  // child: new Image.asset("assets/Images/logo.svg",
                  //     height: 225, width: 225),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SpinKitDualRing(
                        color: Colors.white,
                        size: 180.0,
                      ),
                      //Image.asset("assets/images/logo.png",
                         // height: 180, width: 180)
                         RichText(text: TextSpan(text: 'N', style: TextStyle(color: Colors.white, fontFamily: "Monbaiti", fontSize: 100)))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                          text: 'News \n One',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Monbaiti",
                              fontSize: 72.0))),
                )
              ],
            ),
          )),
    );
  }

  void checkUserLoggedInLocally() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getBool("loggedIn")) {
      Navigator.pushReplacementNamed(context, "/newsscreen");
    }
  }
}
