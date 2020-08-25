import 'package:flutter/material.dart';
import 'package:newsone/pages/bookmarkCategory.dart';
import 'package:newsone/pages/bookmarkNewsDisplay.dart';
import 'package:newsone/pages/profile.dart';
import 'package:newsone/pages/savedBookmarks.dart';
import 'package:newsone/pages/spalshscreen.dart';
import './pages/auth.dart';
import './pages/homescreen.dart';
import './pages/newsScreen.dart';
import './pages/newsWebView.dart';
import './pages/noInternet.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsOne',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
         '/':(context)=> SpalshScreen(),
        '/auth': (context) => AUth(),
        '/home': (context) => HomeScreen(),
        '/newsscreen' : (context) => NewsScreen(),
        '/newsdetails' : (context) => NewsWebview(),
        '/bookmarkCategory' : (context) => BookmarkCategory(),
        '/profile' : (context) => Profile(),
        '/savedBookmark' : (context) => SavedBookmark(),
        'bookmarkDisplay' : (context) => BookmarkNewsDisplay(),
        '/noInternet' : (context) => NoInternet()
      },
    );
  }
}
