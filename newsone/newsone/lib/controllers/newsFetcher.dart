import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FetchNews {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static Future<dynamic>  getNews() async {
    final SharedPreferences prefs = await _prefs;
    var token = await prefs.getString("jwtToken");
   // print(token);
    // Map<String, String> headers = {"authToken": prefs.getString("jwtToken")};
    Map<String, dynamic> UserData = {"authToken": prefs.getString("jwtToken")};
    http.Response newsResposne = await http.post(
        "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/news/fetch/all",
        body: json.encode(UserData));

    var newsData = json.decode(newsResposne.body);
    //print(newsData);
    return newsData['data']['News'];
  }

  static Future<dynamic> getNewsById(String newsID) async {
    print(newsID);

    http.Response newsResposne = await http.get(
      "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/news/fetch/" +
          newsID,
    );

    var newsData = json.decode(newsResposne.body);
    // print(newsData);
    return newsData['data'];
  }
}
