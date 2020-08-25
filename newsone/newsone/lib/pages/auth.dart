import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:newsone/model/NotificationManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../controllers/userAuth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AUth extends StatefulWidget {
  AUth({Key key}) : super(key: key);

  @override
  _AUthState createState() => _AUthState();
}

class _AUthState extends State<AUth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  NotificationManager _notificationMgr = NotificationManager();
  double height = 0.0;

  Future<void> saveData(FirebaseUser user) async {
    final SharedPreferences prefs = await _prefs;
    // print("Token is ++++++++flu "+prefs.getString("notificationToken"));
    prefs.setString("displayName", user.displayName);
    prefs.setString("imageUrl", user.photoUrl + "?height=1080");
    prefs.setString("email", user.email);
    prefs.setString("userid", user.uid);
    prefs.setString("loginUsing", user.providerId);
    
    if(!await UserAuth.isUserAlreadyRegister(user.uid)){
       Navigator.pushReplacementNamed(context, "/home");
    }else{
       Navigator.pushReplacementNamed(context, "/newsscreen");
    }
   
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserLoggedInLocally();
    _notificationMgr.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Container(child: Text("loading"),);
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(bottom: 25),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Image.asset("assets/images/background.svg"),
                  SizedBox(height: MediaQuery.of(context).size.height/22,),
                  SvgPicture.asset("assets/images/background.svg"),
                  SizedBox(height: MediaQuery.of(context).size.height/7,),
                  createGoogleSignInButton(),
                  SizedBox(
                    height: 20.0,
                  ),
                  createFacebookButton(),
                  // GoogleSignInButton(
                  //   onPressed: () {
                  //     _signIn().then((FirebaseUser user) async {
                  //       saveData(user);
                  //     });
                  //   },
                  // ),
                  // FacebookSignInButton(onPressed: () {
                  //   _signInFacebook().then((FirebaseUser user) async {
                  //     saveData(user);
                  //   });
                  // })
                ])));
  }
  Widget createGoogleSignInButton(){
    return ButtonTheme(
      buttonColor: Colors.black,
      minWidth: MediaQuery.of(context).size.width-80.0,
      height: MediaQuery.of(context).size.height/10.5,
      child: RaisedButton(
        elevation: 6.0,
        color: Color(0xFF957AFF),
        onPressed: (){
          _signIn().then((FirebaseUser user) async { 
            saveData(user);
          });
        },
        child: RichText(text: TextSpan(
          text: 'Login with Google',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "GilroyLight",
            fontSize: 24.0
          )
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        textTheme: ButtonTextTheme.normal,
        ),
    );
  }
  
  Widget createFacebookButton(){
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width-80.0,
      height: MediaQuery.of(context).size.height/10.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0)
      ),
      textTheme: ButtonTextTheme.normal,
      child:RaisedButton(
        elevation: 6.0,
        color: Color(0xFF957AFF),
        onPressed: (){
          _signInFacebook().then((FirebaseUser user) async {
           
            
            saveData(user);
          });
        },
        child: RichText(text: TextSpan(
          text: 'Login with Facebook',
          style: TextStyle(
            fontFamily: "GilroyLight",
            color: Colors.white,
            fontSize: 24.0
          )
        )),
        )
    );
  }


  Future<FirebaseUser> _signIn() async {
   
    final GoogleSignInAccount Gaccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication GAccountAuth =
        await Gaccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: GAccountAuth.accessToken, idToken: GAccountAuth.idToken);

    final FirebaseUser User =
        (await _auth.signInWithCredential(credential)).user;
    print("userid " + User.displayName);
     print(User);
    return User;
  }

  Future<FirebaseUser> _signInFacebook() async {
    final result = await facebookLogin
        .logIn(['email', 'public_profile']);

    if (result.accessToken.token != null) {
      print(result.accessToken.token.toString());
      AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      FirebaseUser User =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      print(User);
      return User;
    }
  }

  void checkUserLoggedInLocally()async{
       final SharedPreferences prefs = await _prefs;
       if(prefs.getBool("loggedIn")){
         Navigator.pushReplacementNamed(context, "/newsscreen");
       }
  }
}
