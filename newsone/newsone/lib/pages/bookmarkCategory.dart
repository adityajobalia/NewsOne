import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/userAuth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class BookmarkCategory extends StatefulWidget {
  _BookmarkCategoryState createState() => _BookmarkCategoryState();
}

class _BookmarkCategoryState extends State<BookmarkCategory> {
  Color mycolor = Colors.red;
  List<String> selectedTopics = new List();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isupdating = false;
  bool isDataChanged = false;
  // @override
  // Future<void> initState() async {
  //   // TODO: implement initState
  //   super.initState();
  //    getTopics();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xFF957AFF),
            onPressed: !isupdating? () {
              Navigator.pop(context, isDataChanged);
            } : null),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              color: Color(0xFF957AFF),
              onPressed: () {
                Navigator.pushNamed(context, "/profile");
              })
        ],
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color(0xFF957AFF),
            ),
        backgroundColor: Colors.white24,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: loadWidgetWhenDataAppears(context)),
    );
  }

Widget mainArea(){
  return Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/savedBookmark");
                    },
                    child: createBookmarkCard(),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10.0,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Card(
                      shadowColor: Color(0xFF957AFF),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10.0, bottom: 60.0),
                            child: createCategoryTitle(),
                          ),
                          Expanded(
                            child: categoryListDisplay(context),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 60, bottom: 40),
                            child: createSubmitButton(),
                          )
                          //
                        ],
                      ),
                    ),
                  ))
                ],
              ));
}

  Widget createSubmitButton() {
    return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 180.0,
        height: MediaQuery.of(context).size.height / 15.5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        textTheme: ButtonTextTheme.normal,
        child: RaisedButton(
          elevation: 6.0,
          color: Color(0xFF957AFF),
          onPressed: () async {
            
            setState(() {
              isupdating = true;
            });
            await setTopics();
          },
          child: RichText(
              text: TextSpan(
                  text: 'Update',
                  style: TextStyle(
                      fontFamily: "PoppinsRegular",
                      color: Colors.white,
                      fontSize: 24.0))),
        ));
  }

  Widget createCategoryTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: RichText(
              text: TextSpan(
                  text: "Suggested categories",
                  style: TextStyle(
                      fontFamily: "PoppinsRegular",
                      fontSize: 20.0,
                      color: Colors.black87))),
        ),
        
      ],
    );
  }

  Widget createBookmarkCard() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width - 10.0,
      child: Card(
        shadowColor: Color(0xFF957AFF),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        borderOnForeground: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: RichText(
                  text: TextSpan(
                      text: "Saved bookmarks",
                      style: TextStyle(
                          fontFamily: "PoppinsRegular",
                          fontSize: 20.0,
                          color: Colors.black87))),
            ),
            Opacity(
              opacity: 1.0,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF957AFF),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryListDisplay(BuildContext context) {
    var leftArray = [
      'https://images.unsplash.com/photo-1507668077129-56e32842fceb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1517649763962-0c623066013b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1532012197267-da84d127e765?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1444653614773-995cb1ef9efa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80'
    ];

    var rightArray = [
      'https://images.unsplash.com/photo-1530025809667-1f4bcff8e60f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1535402803947-a950d5f7ae4b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=60'
    ];

    var leftArrayTitle = [
      'Science',
      'Sports',
      'Education',
      'Business',
      'Travel'
    ];

    var rightArrayTitle = [
      'Politics',
      'World',
      'Entertainment',
      'Technology',
      'Fashion'
    ];

    return ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Column(
                  children: <Widget>[
                    createArray(leftArrayTitle, leftArray, index)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Column(
                  children: <Widget>[
                    createArray(rightArrayTitle, rightArray, index)
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget createArray(
      List<String> arrayTitle, List<String> arrayValue, int index) {
    return GestureDetector(
      onTap: () {
        if (selectedTopics.contains(arrayTitle[index].toLowerCase())) {
          selectedTopics.remove(arrayTitle[index].toLowerCase());
          setState(() {});
        } else {
          selectedTopics.add(arrayTitle[index].toLowerCase());
          setState(() {});
        }
      },
      child: CircleAvatar(
          radius: 72,
          backgroundColor:
              selectedTopics.contains(arrayTitle[index].toLowerCase())
                  ? Color(0xFF957AFF)
                  : Colors.white,
          child: Opacity(
              opacity: selectedTopics.contains(arrayTitle[index].toLowerCase())
                  ? 0.5
                  : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.black,
                    child: Opacity(
                      opacity: 0.45,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(arrayValue[index]),
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                    text: arrayTitle[index],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
                ],
              ))),
    );
  }

  Future<void> getTopics() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getStringList("topics") != null &&
        prefs.getStringList("topics").length > 0) {
      selectedTopics = prefs.getStringList("topics");
      setState(() {});
    }
  }

  Future<void> setTopics() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("topics", selectedTopics);

    await UserAuth.registerUser(selectedTopics, prefs.getString("city"));
    setState(() {
      isupdating =false;
      isDataChanged = true;
    });
  }
  
  Widget loadWidgetWhenDataAppears(BuildContext context) {
    if (!isupdating) {
      return mainArea();
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
}
