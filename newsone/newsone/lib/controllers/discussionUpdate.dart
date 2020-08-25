import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDiscussion {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static Future<void> createDiscussion(
      String title, String description, String newsId) async {
    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> DiscussionBody = {
      'username': prefs.getString("displayName"),
      'userImage': prefs.getString("imageUrl"),
      'userid': prefs.getString("userid"),
      'title': title,
      'discription': description,
      'newsid': newsId
    };
    http.Response response = await http.post(
        "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/discussion/create",
        body: json.encode(DiscussionBody));
    var discussionResponse = json.decode(response.body);
    if (discussionResponse != null && discussionResponse['code'] == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> addCommentToDiscussion(
      String comment, String discussionId) async {
    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> CommentToDiscussionBody = {
      'userDisplayName': prefs.getString("displayName"),
      'userImage': prefs.getString("imageUrl"),
      'userid': prefs.getString("userid"),
      'comment': comment,
      'discussionid': discussionId
    };
    http.Response response = await http.post(
        "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/discussion/comment/add",
        body: json.encode(CommentToDiscussionBody));
    var discussionResponse = json.decode(response.body);
    if (discussionResponse != null && discussionResponse['code'] == 0) {
      return true;
    } else {
      return false;
    }
  }
}
