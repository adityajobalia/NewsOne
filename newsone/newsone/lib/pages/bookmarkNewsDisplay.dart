import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:newsone/controllers/newsFetcher.dart';

class BookmarkNewsDisplay extends StatefulWidget{
  dynamic newsID;
  BookmarkNewsDisplay({Key key, this.newsID}) : super(key:key);
  _BookmarkNewsState createState() => _BookmarkNewsState(this.newsID);
}

class _BookmarkNewsState extends State<BookmarkNewsDisplay>{
  dynamic newsID;
  dynamic news;
  bool isDataLoaded = false;
  _BookmarkNewsState(this.newsID);
  @override
  void initState() { 
    super.initState();
    fetchNewsFromID();
  }

  void fetchNewsFromID() async{
    print("=================");
    print(newsID);
     news= await FetchNews.getNewsById(newsID);
        isDataLoaded = true;
    setState(() {
      print(isDataLoaded);

    });
  }
Widget loadWidgetWhenDataAppears(BuildContext context){

    if(isDataLoaded){
      return loadNewsFromId();
    }else{
        return Center(
        child:Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height/2,
          child: new Image(image: new AssetImage("assets/Images/infinite.gif")),
        )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),color: Color(0xFFFCC050), onPressed: (){
            Navigator.of(context).pop();
          }), 
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color(0xFFFCC050),
          ),
          backgroundColor: Colors.white24,
          elevation: 0.0,
      ),
      body: SafeArea(
        top: false,
        child: loadWidgetWhenDataAppears(context)),
    );
  }

  Widget loadNewsFromId(){
    return Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height/3,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(
                        news['urlToImage']))),
          ),
          Container(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/8,
            child: RichText(
                text: TextSpan(
                    text:
                       news['title'],
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontFamily: 'OpenSansRegular',
                        fontWeight: FontWeight.normal))),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height/3) + 15,
            child: RichText(
                text: TextSpan(
                    text: news['description'],
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: 'OpenSansLight'))),
          ),
        ],
      );
  }
}