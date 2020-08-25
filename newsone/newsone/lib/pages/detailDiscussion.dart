import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import '../controllers/discussionUpdate.dart';
import '../controllers/fetchDiscussion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class DetailDiscussion extends StatefulWidget {
  dynamic Discussion;
  String discussionId;
  DetailDiscussion({Key key, this.Discussion, this.discussionId})
      : super(key: key);
  _DetailDiscussionNews createState() =>
      _DetailDiscussionNews(this.Discussion, this.discussionId);
}

class _DetailDiscussionNews extends State<DetailDiscussion> {
  dynamic Discussion;
  String discussionId;
  bool isDataLoaded = true;
  bool isDataChanged = false;
  final commentController = TextEditingController();
  _DetailDiscussionNews(this.Discussion, this.discussionId);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshPage();
  }

  void refreshPage() async {
     setState(() {
      isDataLoaded = false;
      isDataChanged = true;
    });
    print("Draged");
   dynamic tempData = await FetchDiscussion.getAllDiscussions(discussionId);
    Discussion=tempData['data'];
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            // bottomNavigationBar: BottomAppBar(
            //   child: Container(
            //       height: 50.0,
            //       child: Positioned(
            //         bottom: MediaQuery.of(context).viewInsets.bottom,
            //         left: 0,
            //         right: 0,
            //         child: createCommentTextField(),
            //       )),
            //   elevation: 9.0,
            //   shape: CircularNotchedRectangle(),
            //   color: Colors.white,
            //   notchMargin: 8.0,
            // ),

            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Color(0xFF957AFF),
                  onPressed: () {
                    Navigator.pop(context,isDataChanged);
                  }),
                  actions: [
                    IconButton(icon: Icon(Icons.refresh),color: Color(0xFF957AFF), onPressed: (){refreshPage();})
                  ],
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Color(0xFF957AFF),
                  ),
              backgroundColor: Colors.white24,
              elevation: 0.0,
            ),
            body: GestureDetector(
              onVerticalDragEnd: (data){
                refreshPage();
              },
              child: loadWidgetWhenDataAppears(context),
            )));
  }

  Widget mainLayout(){
    return FooterLayout(
                // color: Colors.black54,
                //
                child: Container(
                  
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                        
                            width: MediaQuery.of(context).size.width - 20.0,
                            //height: MediaQuery.of(context).size.height/2 ,
                            child: Column(
                              //mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Card(
                                  color: Color(0xFF957AFF),
                                  shadowColor: Color(0xFF957AFF),
                                  elevation: 10.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Column(children: <Widget>[
                                    Container(
                                      
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              setCircleAvatar(
                                                  Discussion['createdBy']
                                                              ['userImage'] ==
                                                          null
                                                      ? ""
                                                      : Discussion['createdBy']
                                                          ['userImage']),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              setDiscussionName(Discussion['createdBy']
                                                  ['userDisplayName']),
                                              
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20.0,
                                        child: setDiscussionTitle(
                                            Discussion['title'])),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: ListView(
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            setDiscussionBody(
                                                Discussion['description'])
                                          ]),
                                    )
                                  ]),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: setCommentSection(),
                          ),
                        )
                        // Container(
                        //   width: MediaQuery.of(context).size.width-20.0,
                        //   child: Row(
                        //     children: <Widget>[
                        //       Align(
                        //         alignment: Alignment.bottomCenter,
                        //         child: createCommentTextField(),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    )),
                footer: Container(
                  height: 50.0,
                  child: createCommentTextField(),
                ),
              );
  }

    Widget loadWidgetWhenDataAppears(BuildContext context){
    if(isDataLoaded && Discussion != null ){
      return mainLayout();
    }else{
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

  Widget setCircleAvatar(String imageURL) {
    return Padding(
      padding:
          EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Container(
              child: CircleAvatar(
            radius: 15.0,
            backgroundImage: NetworkImage(imageURL),
          )),
        ],
      ),
    );
  }

  Widget setName(String name) {
    return Align(
      heightFactor: 2.2,
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(
              text: name,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  fontFamily: 'PoppinsLight',
                  fontSize: 20))),
    );
  }

  Widget setDiscussionName(String name) {
    return Align(
      heightFactor: 2.2,
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(
              text: name,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.white54,
                  fontFamily: 'PoppinsLight',
                  fontSize: 20))),
    );
  }

  Widget setDiscussionTitle(String title) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0, bottom: 10.0),
      child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PoppinsRegular',
                  color: Colors.white,
                  fontSize: 20))),
    );
  }

  Widget setDiscussionBody(String description) {
    return Container(
        padding:
            EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0, bottom: 10.0),
        child: RichText(
            text: TextSpan(
                text: description,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'PoppinsLight',
                    color: Colors.white70,
                    fontSize: 20))));
  }

  Widget createCommentTextField() {
    return Container(
        child: new TextField(
      controller: commentController,
      onSubmitted: (String commentData)async {
        commentController.text = "";
        print(commentData);
        if(commentData.trim().length>0 && commentData.isNotEmpty){
          await UpdateDiscussion.addCommentToDiscussion(
            commentData, Discussion['discussionid']);
            refreshPage();
        }
        
      },
      decoration: InputDecoration(
        hintText: "Write comment",
        enabledBorder: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.black38),
        ),
        focusedBorder: new OutlineInputBorder(
          borderSide: new BorderSide(
            color: Color(0xFF957AFF),
          ),
        ),
      ),
    ));
  }

  Widget setCommentSection() {
    //print(Discussion['comments']);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: Discussion['comments'].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.only( left: 10.0, right: 10.0,bottom: 10.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width - 20.0,
                  //height: MediaQuery.of(context).size.height/2 ,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(children: <Widget>[
                          Container(
                            
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    setCircleAvatar(Discussion["comments"]
                                        [index]["userImage"]),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    setName(Discussion["comments"][index]
                                        ["userDisplayName"]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width - 20.0,
                              child: setCommentBody(
                                  Discussion["comments"][index]["comment"])),
                          Container(
                              //height:
                              //MediaQuery.of(context).size.height / 4 ,
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 25.0),
                              child: setCommentDate(
                                  formatDateTime(Discussion["comments"][index]["createdAt"])))
                        ]),
                      ),
                    ],
                  )),
            ),
          );
        });
  }

  Widget setCommentBody(String comment) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0, bottom: 10.0),
      child: RichText(
          text: TextSpan(
              text: comment,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'PoppinsLight',
                  color: Colors.black87,
                  fontSize: 20))),
    );
  }

  Widget setCommentDate(String postDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Opacity(
          opacity: 0.2,
          child: Padding(padding: EdgeInsets.only(bottom: 10.0,right: 5.0),child: Icon(
          Icons.access_time,
          size: 16.0,
        ),),),
        Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0, bottom: 10.0),
      child: RichText(
          text: TextSpan(
              text: postDate,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'PoppinsLight',
                  color: Colors.black26,
                  fontSize: 14))),
    )
      ],
    );
  }

  String formatDateTime(dynamic createdAt){

    if(createdAt['days']>0){
      return createdAt['days'].toString() + " Days Ago";
    }else if(createdAt['hours']>0){
       return createdAt['hours'].toString() + " Hours Ago";
    }else if(createdAt['minutes']>0){
       return createdAt['minutes'].toString() + " Minutes Ago";
    }else if(createdAt['seconds']>0){
       return createdAt['seconds'].toString() + " Seconds Ago";
    }

  }
}
