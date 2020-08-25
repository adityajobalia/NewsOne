
import 'dart:io';
import 'package:flutter/material.dart';

class CheckInternet {

  static void checkInternet(BuildContext context,String redirectPath) async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return;
      }
    } on SocketException catch (_) {
     Navigator.pushReplacementNamed(context, "/noInternet");
    }
  }

}