import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class NewsWebview extends StatefulWidget {

  NewsWebview({Key key}) : super(key: key);

  @override
  _NewsWebviewState createState() => _NewsWebviewState();
}

class _NewsWebviewState extends State<NewsWebview> {
   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var title ="";
  var url = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   loadNewsInDetail();
  }
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
    url: url,
    withJavascript: true, 
    withZoom: false, 
    // appBar: AppBar(
    //   title: Text(title),
    //   elevation: 1
    // ),
    appBar:  AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xFF957AFF),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
                  
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Color(0xFF957AFF),
                  ),
                  title: Text(title),
              backgroundColor: Colors.white24,
              elevation: 0.0,
            ),
  );
    
  }

  void loadNewsInDetail() async{
    final SharedPreferences prefs = await _prefs;
   url=  prefs.getString("detailurl");
    title= prefs.getString("detailtitle");
    setState(() {
    
    });
  }
}