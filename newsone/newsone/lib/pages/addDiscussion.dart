import 'package:flutter/material.dart';
import '../controllers/discussionUpdate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class AddDiscussion extends StatefulWidget{
  String newsid;
  AddDiscussion({Key key,this.newsid}): super(key:key);
  _AddDiscussionContent createState() => _AddDiscussionContent(newsid);
}

class _AddDiscussionContent extends State<AddDiscussion>{
  String newsid;
  final titleController = TextEditingController();
  final descrptionController = TextEditingController();
  bool isCreatingDiscussion = false;
  _AddDiscussionContent(this.newsid);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),color: Color(0xFF957AFF), onPressed: (){
            Navigator.pop(context,false);
          }),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color(0xFF957AFF),
          ),
          title: Text("Add Discussion"),
          backgroundColor: Colors.white24,
          elevation: 0.0,
        ),
        body: loadWidgetWhenDataAppears(context),
      )
      );
  }

  Widget loadMainBody(){

    return Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: createTitleField(context),
            ),
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: createDescription(),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.only(left: 35.0, right: 35.0),
              child: createButton(context),
            )
          ],
        )
    );
  }


  Widget createTitleField(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: new TextField(
        controller: titleController,
        textAlign: TextAlign.start,
        cursorColor: Colors.black,
                  decoration: InputDecoration(  
                   enabledBorder: new UnderlineInputBorder(
                     borderSide: new BorderSide(
                        color: Colors.black38
                   ),
                   ),
                   focusedBorder:new UnderlineInputBorder(
                     borderSide: new BorderSide(
                        color: Color(0xFF957AFF)
                   ),
                   ) ,
                   border: new UnderlineInputBorder(
                     borderSide: new BorderSide(
                        color: Color(0xFF957AFF)
                   ),
                   ),
                    hintText: 'Title',
            
                    ),
            ),
    );
  }

  Widget createDescription(){
    return Container(
      margin: EdgeInsets.only(top: 30.0),
      child: new TextField(
        controller: descrptionController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
        hintText: "Description",
        enabledBorder: new OutlineInputBorder(
                     borderSide: new BorderSide(
                        color: Colors.black38
                   ),
                   ),
                   focusedBorder:new OutlineInputBorder(
                     borderSide: new BorderSide(
                        color: Color(0xFF957AFF),
                   ),
                   ) ,  
        ),
        maxLines: 10,
    )
    );
  }

  Future<bool> checkTextField() async{
    if(titleController.text.isNotEmpty && descrptionController.text.isNotEmpty && titleController.text.trim().length>0 && descrptionController.text.trim().length>0){
      return true;
    }
    return false;
  }


  Widget loadWidgetWhenDataAppears(BuildContext context) {
    if (!isCreatingDiscussion) {
      return loadMainBody();
    }
    else {
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

  Widget createButton(BuildContext context){
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width/3,
      height: MediaQuery.of(context).size.height/20,
      child: new OutlineButton(
        onPressed: ()async{
          if(await checkTextField()){
            setState((){
              isCreatingDiscussion = true;
            });
            await UpdateDiscussion.createDiscussion(titleController.text, descrptionController.text, newsid);
            Navigator.pop(context,true);
          }
          else{
            setState(() {
              titleController.clear();
              descrptionController.clear();
            });
          }
      },
      child: Text("Create"),
      highlightedBorderColor: Color(0xFF957AFF),
      borderSide: BorderSide(color: Color(0xFF957AFF)),
      highlightColor: Colors.white24,
      textColor: Color(0xFF957AFF),
      textTheme: ButtonTextTheme.normal,
      highlightElevation: 10.0,
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      ),
    );
    
  }
  
}