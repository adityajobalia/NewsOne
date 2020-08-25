import 'package:flutter/material.dart';

class LoadingComplete extends StatefulWidget{
  _LoadingCompleteState createState() => _LoadingCompleteState();
}

class _LoadingCompleteState extends State<LoadingComplete>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top:150),
                child: Image.asset("assets/Images/tick.png", height: 150, width: 150,),
              ),
              Container(
                padding: EdgeInsets.only(top:30),
                child: RichText(
                  text: TextSpan(
                    text: 'Great!!',
                    style: TextStyle(
                      fontFamily: "Monbaiti",
                      color: Color(0XFF957AFF),
                      fontSize: 54.0,
                      fontWeight: FontWeight.w500
                    )
                )),
              ),
              Container(
                padding: EdgeInsets.only(top:150),
                child: RichText(
                  text: TextSpan(
                    text: 'You are all caught up!',
                    style: TextStyle(
                      fontFamily: "Monbaiti",
                      color: Color(0XFF957AFF),
                      fontSize: 34.0,
                      fontWeight: FontWeight.w500
                    )
                )),
              )
            ],
          ),
      )),
    );
  }
}