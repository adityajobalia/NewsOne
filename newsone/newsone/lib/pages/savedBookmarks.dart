import 'package:flutter/material.dart';
import 'package:newsone/pages/bookmarkNewsDisplay.dart';
import 'package:newsone/pages/newsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedBookmark extends StatefulWidget {
  _SavedBookmarkState createState() => _SavedBookmarkState();
}

class _SavedBookmarkState extends State<SavedBookmark> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var bookmarkList = [];
  var news = [];
  //String newsID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookmarkData();
  }

  void getBookmarkData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      bookmarkList = prefs.getStringList("bookmarks");
      news = prefs.getStringList("newsID");
      // print("=================+++++++++++++++++++++++");
      // print(news);
    });

    print(bookmarkList);
  }

  Widget check() {
    if (news != null && news.length > 0) {
      return createListView(context);
    } else {
      return Center(child: Text('No saved bookmarks'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xFF957AFF),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Color(0xFF957AFF), fontFamily: "PoppinsRegular"),
        title: Text("Saved bookmarks"),
        backgroundColor: Colors.white24,
        elevation: 0.0,
      ),
      body: SafeArea(child: Container(child: check())),
    );
  }

  Widget createTitle(bookmarkList, int index) {
    return RichText(
        text: TextSpan(
            text: bookmarkList[index],
            style: TextStyle(
                color: Colors.white,
                fontFamily: "PoppinsLight",
                fontSize: 18.0)));
  }

  Widget createButton(BuildContext context, int index) {
    return ButtonTheme(
      child: new OutlineButton(
        onPressed: () {
          print('Delete pressed');
          bookmarkList.removeAt(index);
          news.removeAt(index);

          deleteFromPrefs();
        },
        child: IconButton(icon: Icon(Icons.delete_sweep), onPressed: (){print('Delete pressed');
          bookmarkList.removeAt(index);
          news.removeAt(index);

          deleteFromPrefs();}, color: Colors.white),
        highlightedBorderColor: Color(0xFF957AFF),
        borderSide: BorderSide(color: Colors.white,width: 2.0),
        highlightColor: Colors.white24,
        textColor: Color(0xFF957AFF),
        textTheme: ButtonTextTheme.normal,
        highlightElevation: 10.0,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }

  Widget createListView(BuildContext context) {
    return ListView.builder(
        itemCount: bookmarkList == null ? 0 : bookmarkList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print("++++++++++++++");
              print(news);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookmarkNewsDisplay(
                            newsID: news[index],
                          )));
            },
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
              width: MediaQuery.of(context).size.width - 10.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Color(0xFF957AFF),
                  shadowColor: Color(0xFF957AFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 10.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                              child: createTitle(bookmarkList, index),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: createButton(context, index),
                            ),
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void deleteFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("bookmarks", bookmarkList);
    prefs.setStringList("newsID", news);
    setState(() {});
  }
}
