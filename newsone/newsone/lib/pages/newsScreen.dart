import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:newsone/model/NotificationManager.dart';
import 'package:newsone/pages/discussion.dart';
import 'package:swipedetector/swipedetector.dart';
import '../controllers/newsFetcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({Key key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  File _image;
  ScreenshotController screenshotController = ScreenshotController();
  List<String> bookmarks = new List();
  //int _selectedIndex = 0;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool flag = true;
  var NewsList = [];
  var currentPage = 0;
  bool isDataLoaded = false;
  double opacity = 0.0;
  bool floatButtonVisibility = false;
  Color bookmarkColor = Colors.white;
  List<String> bookmarkList = List();
  List<String> newsId = List();
  bool bookmarkVisibility = false;
  //bool appbar = false;

  @override
  void initState() {
    //NotificationManager _notificationMgr = NotificationManager();
    //_notificationMgr.initState();
    // TODO: implement initState
    super.initState();
    // NewsList.add({
    //   "auther": "Tom Blackwell",
    //   "sourceName": "National Post",
    //   "urlToImage":
    //       "https://nationalpostcom.files.wordpress.com/2020/06/long-term-care-1-1.png",
    //   "category": "politics",
    //   "createdAt": 1593188671853,
    //   "description":
    //       "Residents of the most tightly packed facilities were twice as likely to get infected and to die as those in the least-crowded homes, concluded the paper",
    //   "url":
    //       "https://nationalpost.com/health/eliminating-multi-bed-rooms-in-nursing-homes-could-have-saved-many-lives-study",
    //   "newsid": "ba88fed7-7266-4489-9e08-2445c7cd4d95",
    //   "title":
    //       "Hundreds of COVID-19 deaths could have been prevented by eliminating four-person nursing-home rooms: study - National Post"
    // });
    fetchUINews();
    getNewsBookmark();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: BottomNavigationBar(
        //   onTap: _onItemTapped,
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.bookmark), title: Text('Bookmark')),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.share), title: Text('Share')),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.chat), title: Text('Discussions'))
        //   ],
        //   selectedItemColor: Color(0xFF957AFF),
        //   unselectedItemColor: Color(0xFF957AFF),

        // ),

        resizeToAvoidBottomPadding: false,
        body: GestureDetector(
          onTap: () {
            setState(() {
              if (floatButtonVisibility) {
                opacity = 0.0;
                floatButtonVisibility = false;
              } else {
                floatButtonVisibility = true;
                opacity = 1.0;
              }
            });
          },
          child: SwipeDetector(
            onSwipeLeft: () {
              setState(() {
                print("Swipe left");
                loadDetailNews();
              });
            },
            onSwipeRight: () {
              setState(() {
                // print("Swipe right");
                Navigator.pushNamed(context, "/bookmarkCategory")
                    .then((value) async {
                  //print('================');
                  getNewsBookmark();
                  setState(() {});
                  if (value) {
                    setState(() {
                      isDataLoaded = false;
                    });
                    fetchUINews();
                  }
                });
              });
            },
            swipeConfiguration: SwipeConfiguration(
                horizontalSwipeMaxHeightThreshold: 80.0,
                horizontalSwipeMinDisplacement: 80.0,
                horizontalSwipeMinVelocity: 400.0),
            child: SafeArea(
              top: false,
              child: Screenshot(
                controller: screenshotController,
                //color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    // createNewsView(context),
                    loadWidgetWhenDataAppears(context)
                    // Positioned(
                    //   bottom: 0.0,
                    //   child: switcher(),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget loadWidgetWhenDataAppears(BuildContext context) {
    if (isDataLoaded) {
      if (NewsList.length == 0) {
        return allNewsCompleted();
      } else {
        return createNewsView(context);
      }
      // return createNewsView(context);
    } else {
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

  switcher() {
    if (flag) {
      flag = false;
    } else {
      flag = false;
    }
  }

  Widget createNewsView(BuildContext context) {
    return PageView.builder(
      onPageChanged: (int page) {
        currentPage = page;
      },
      itemCount: NewsList.length,
      itemBuilder: (context, position) {
        //fetchBookmarkData(position,NewsList);
        currentPage = position;

        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new NetworkImage(
                            NewsList[position]['urlToImage']))),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height / 8,
                child: RichText(
                    text: TextSpan(
                        text: NewsList[position]['title'],
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontFamily: 'PoppinsMedium',
                            fontWeight: FontWeight.normal))),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height / 3) + 15,
                child: RichText(
                    text: TextSpan(
                        text: NewsList[position]['description'],
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontFamily: 'PoppinsLight'))),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Opacity(
                            opacity: opacity,
                            child: new FloatingActionButton(
                                tooltip: "Bookmark news",
                                heroTag: "flot1" + position.toString(),
                                onPressed: () {
                                  setState(() {
                                    if (bookmarkColor == Colors.red) {
                                      bookmarkColor = Colors.white;
                                      removeBookmark(NewsList, position);
                                    } else {
                                      bookmarkColor = Colors.red;
                                      saveBookmark(NewsList, position);
                                    }
                                  });
                                },
                                elevation: 15.5,
                                // child: Icon(
                                //   Icons.bookmark_border,
                                //   color: bookmarks.contains(
                                //           NewsList[position]['newsid'])
                                //       ? Colors.red
                                //       : Colors.white,
                                // ),
                                child: bookmarks
                                        .contains(NewsList[position]['newsid'])
                                    ? Icon(Icons.bookmark)
                                    : Icon(Icons.bookmark_border),
                                backgroundColor: Color(0xFF957AFF))),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Opacity(
                            opacity: opacity,
                            child: new FloatingActionButton(
                                tooltip: "Share news",
                                heroTag: "flot2" + position.toString(),
                                onPressed: () {
                                  setState(() {
                                    opacity = 0.0;
                                    floatButtonVisibility = false;
                                  });
                                  _takeScreenshot();
                                },
                                elevation: 15.5,
                                child: Icon(Icons.share),
                                backgroundColor: Color(0xFF957AFF))),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Opacity(
                          opacity: opacity,
                          child: Badge(
                              badgeContent: Text(NewsList[position]
                                      ['discussions']
                                  .length
                                  .toString()),
                              badgeColor: Colors.red[200],
                              child: new FloatingActionButton(
                                  tooltip: "Discussion",
                                  heroTag: "flot3" + position.toString(),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Discussion(
                                                  allDiscussion:
                                                      NewsList[position]
                                                          ['discussions'],
                                                  newsid: NewsList[position]
                                                      ['newsid'],
                                                ))).then((value) {
                                      setState(() {
                                        NewsList[position]['discussions'] =
                                            value;
                                      });
                                    });
                                  },
                                  elevation: 15.5,
                                  child: Icon(Icons.chat),
                                  backgroundColor: Color(0xFF957AFF))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      scrollDirection: Axis.vertical,
    );
  }

  void fetchUINews() async {
    NewsList = await FetchNews.getNews();
    isDataLoaded = true;
    setState(() {});
  }

  void getNewsBookmark() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getStringList("newsID") != null &&
        prefs.getStringList("newsID").length > 0) {
      bookmarks = prefs.getStringList("newsID");
    } else {
      bookmarks = [];
      //print('No stored bookmarks=====');
    }
  }

  Future<bool> fetchBookmarkData(int position, List newsList) async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getStringList("bookmarks") != null) {
      bookmarkList = prefs.getStringList("bookmarks");
      if (bookmarkList.contains(newsList[position]['title'])) {
        setState(() {
          //bookmarkColor = Colors.red;
          bookmarkVisibility = true;
        });
      } else {
        setState(() {
          //bookmarkColor = Colors.white;
          bookmarkVisibility = false;
        });
      }
    }
    return bookmarkVisibility;
  }

  void loadDetailNews() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("detailurl", NewsList[currentPage]['url']);
    prefs.setString("detailtitle", NewsList[currentPage]['title']);
    Navigator.pushNamed(context, "/newsdetails");
  }

  void removeBookmark(newsList, int position) async {
    final SharedPreferences prefs = await _prefs;
    bookmarks = prefs.getStringList("newsID");
    bookmarkList = prefs.getStringList("bookmarks");
    bookmarks.remove(newsList[position]['newsid']);
    bookmarkList.remove(newsList[position]['title']);
    prefs.setStringList("bookmarks", bookmarkList);
    prefs.setStringList("newsID", bookmarks);
    setState(() {});
  }

  void saveBookmark(newsList, int position) async {
    final SharedPreferences prefs = await _prefs;
    print(newsList[position]['title']);
    if (prefs.getStringList("bookmarks") != null) {
      if (prefs
          .getStringList("bookmarks")
          .contains(newsList[position]['title'])) {
        print("Already in bookmarks");
      } else {
        bookmarkList = prefs.getStringList("bookmarks");
        bookmarkList.add(newsList[position]['title']);
        print("NEWS ID======" + newsList[position]['newsid']);
        bookmarks = prefs.getStringList("newsID");
        bookmarks.add(newsList[position]['newsid']);
        prefs.setStringList("bookmarks", bookmarkList);
        prefs.setStringList("newsID", bookmarks);
        print(bookmarkList);
        setState(() {});
      }
    } else {
      bookmarkList.add(newsList[position]['title']);
      newsId.add(newsList[position]['newsid']);
      prefs.setStringList("bookmarks", bookmarkList);
      prefs.setStringList("newsID", newsId);
      setState(() {});
    }
  }

  _takeScreenshot() async {
    _image = null;
    screenshotController.capture(pixelRatio: 2.0).then((File image) async {
      setState(() {
        _image = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _image.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('NewsOne', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget allNewsCompleted() {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 150),
            child: Image.asset(
              "assets/images/tick.png",
              height: 150,
              width: 150,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: RichText(
                text: TextSpan(
                    text: 'Great!!',
                    style: TextStyle(
                        fontFamily: "Monbaiti",
                        color: Color(0XFF957AFF),
                        fontSize: 54.0,
                        fontWeight: FontWeight.w500))),
          ),
          Container(
            padding: EdgeInsets.only(top: 150),
            child: RichText(
                text: TextSpan(
                    text: 'You are all caught up!',
                    style: TextStyle(
                        fontFamily: "Monbaiti",
                        color: Color(0XFF957AFF),
                        fontSize: 34.0,
                        fontWeight: FontWeight.w500))),
          ),
          IconButton(
              icon: Icon(Icons.mode_edit,color: Color(0XFF957AFF),size: 30,),
              onPressed: () {
                setState(() {
                  // print("Swipe right");
                  Navigator.pushNamed(context, "/bookmarkCategory")
                      .then((value) async {
                    //print('================');
                    getNewsBookmark();
                    setState(() {});
                    if (value) {
                      setState(() {
                        isDataLoaded = false;
                      });
                      fetchUINews();
                    }
                  });
                });
              }),
        ],
      ),
    );
  }
}
