import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<bool> isUserAlreadyRegister(String userID) async {
    final SharedPreferences prefs = await _prefs;

    http.Response userResposne = await http.get(
        "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/user/checkuser/" +
            userID);
    var userInfo = json.decode(userResposne.body);


    if (userInfo != null && userInfo['data']['isAlreadyRegister']) {
      prefs.setString("jwtToken", userInfo['data']['jwtToken']);
      prefs.setBool("loggedIn", true);
      return true;
    }
    return false;
  }

  static Future<bool> registerUser(List<String> topics, String city) async {
    final SharedPreferences prefs = await _prefs;

    Map<String, dynamic> UserData = {
      'displayName': prefs.getString("displayName"),
      'imageURL': prefs.getString("imageUrl"),
      'email': prefs.getString("email"),
      'city': city,
      'userid': prefs.getString("userid"),
      'topics': topics.toString(),
      'firebaseToken': prefs.getString("notificationToken"),
      'loginUsing':  prefs.getString("loginUsing"),
    

    };

   
    http.Response response = await http
        .post("https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/user/create", body: json.encode(UserData));
          var userRegister = json.decode(response.body);
        if(userRegister != null && userRegister['data']['statusCode']==0){
          prefs.setString("jwtToken", userRegister['data']['jwtToken']);
           prefs.setBool("loggedIn", true);
          return true;
        }else{
          return false;
        }
  }


  
}
