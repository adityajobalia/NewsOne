import 'package:http/http.dart' as http;
import 'dart:convert';


class FetchDiscussion {


   static Future<dynamic> getAllDiscussions(String discussionId) async {

      http.Response discussionResposne = await http.get(
        "https://t3s37gqjwi.execute-api.ca-central-1.amazonaws.com/dev/api/discussion/get/"+discussionId
       );
    
    var discussionData = json.decode(discussionResposne.body);
    // print(discussionData['data']);
    // print("inside");
    return discussionData;

   }
}