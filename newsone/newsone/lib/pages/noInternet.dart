
import 'package:flutter/material.dart';
import 'dart:io';

class NoInternet extends StatefulWidget {
  NoInternet({Key key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //margin: EdgeInsets.only(top:150.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: new Image.asset("assets/Images/no_internet.gif",
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width),
            ),
            Container(
              alignment: Alignment.center,
              child: RichText(
                  text: TextSpan(
                      text: 'Internet is Not Working',
                      style: TextStyle(
                          color: Color(0xFF957AFF),
                          fontFamily: "Monbaiti",
                          fontSize: 32.0))),
            ),
            IconButton(icon: Icon(Icons.refresh), onPressed: () async {

              checkInternet(context, "/");
            })
          ],
        ),
      )),
    );
  }

  static void checkInternet(BuildContext context,String redirectPath) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
       Navigator.pushReplacementNamed(context, "/");
      }
    } on SocketException catch (_) {
     Navigator.pushReplacementNamed(context, "/noInternet");
    }
  }
}
