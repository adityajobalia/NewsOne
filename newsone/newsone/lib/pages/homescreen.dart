import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../controllers/userAuth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String displayName = "";
  String imageURL = "";
  String email = "";
  String city = "";
  bool _cityField = true;

  final cityTextController = TextEditingController();

  List<String> selectedTopics = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      displayName = prefs.getString("displayName");
      imageURL = prefs.getString("imageUrl");
      email = prefs.getString("email");
    });
  }

  Future<bool> checkCityValidation() async {
    if (cityTextController.text.isNotEmpty &&
        cityTextController.text.trim().length > 0) {
      setState(() {
        _cityField = true;
      });
      return true;
    } else {
      setState(() {
        _cityField = false;
      });
      return false;
    }
  }

  Future<bool> setCityTopics(String city, List<String> selectedTopics) async {
    // print('set city called');
    final SharedPreferences prefs = await _prefs;
    // print('City=== ' + city);
    setState(() {
      prefs.setString("city", city);
      prefs.setStringList("topics", selectedTopics);
      return true;
    });

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color(0xFF957AFF),
            ),
        title: Text("NewsOne"),
        backgroundColor: Colors.white24,
        elevation: 0.0,
        // actions: <Widget>[
        //   FlatButton(
        //     onPressed: () async {
        //       print(selectedTopics);
        //       if (await UserAuth.registerUser(
        //               selectedTopics, cityTextController.text) &&
        //           await setCity(cityTextController.text) && await checkCityValidation()) {
        //         Navigator.pushReplacementNamed(context, "/newsscreen");
        //       } else {
        //         print('Empty field');
        //       }
        //     },
        //     child: Text("Submit"),
        //   )
        // ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                  radius: 60, backgroundImage: NetworkImage(imageURL)),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: createName()),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.topLeft,
                child: createEmail()),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                  text: TextSpan(
                      text: "City",
                      style: TextStyle(
                          fontFamily: "PoppinsRegular",
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          color: Color(0xFF4A4A4A)))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: cityTextController,
                decoration: InputDecoration(
                    hintText: 'Enter City Name',
                    errorText: _cityField ? null : 'City field cannot be empty',
                    focusColor: Color(0xFFFCC050),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF957AFF))),
                    border: new UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: MediaQuery.of(context).size.width),
                    )),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(child: categoryListDisplay(context)),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 40),
              child: createSubmitButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget createName() {
    return Container(
      padding: EdgeInsets.only(top: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
                text: TextSpan(
                    text: "Name",
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                        color: Color(0xFF4A4A4A)))),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: RichText(
                text: TextSpan(
                    text: displayName,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Color(0xFFD6D6D6)))),
          )
        ],
      ),
    );
  }

  Widget createEmail() {
    return Container(
      padding: EdgeInsets.only(top: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RichText(
                text: TextSpan(
                    text: "Email",
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                        color: Color(0xFF4A4A4A)))),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: RichText(
                text: TextSpan(
                    text: email,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        fontWeight: FontWeight.normal,
                        fontSize: 18.0,
                        color: Color(0xFFD6D6D6)))),
          )
        ],
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
                padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    createArray(leftArrayTitle, leftArray, index)
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: <Widget>[
                    createArray(rightArrayTitle, rightArray, index),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget createSubmitButton() {
    return ButtonTheme(
        minWidth: MediaQuery.of(context).size.width - 120.0,
        height: MediaQuery.of(context).size.height / 12.5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        textTheme: ButtonTextTheme.normal,
        child: RaisedButton(
          elevation: 6.0,
          color: Color(0xFF957AFF),
          onPressed: () async {
            print(selectedTopics);
            if (await checkCityValidation()) {
              if (await UserAuth.registerUser(
                  selectedTopics, cityTextController.text)) {
                await setCityTopics(cityTextController.text, selectedTopics);
                Navigator.pushReplacementNamed(context, "/newsscreen");
              }
            } else {
              print('Empty field');
            }
          },
          child: RichText(
              text: TextSpan(
                  text: 'Submit',
                  style: TextStyle(
                      fontFamily: "GilroyLight",
                      color: Colors.white,
                      fontSize: 24.0))),
        ));
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
}
