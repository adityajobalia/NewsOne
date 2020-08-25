import 'package:newsone/pages/addDiscussion.dart';
import 'package:newsone/pages/detailDiscussion.dart';
import 'package:flutter/material.dart';
import '../controllers/fetchDiscussion.dart';
import '../controllers/newsFetcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Discussion extends StatefulWidget {
  List<dynamic> allDiscussion;
  String newsid;

  Discussion({Key key, this.allDiscussion, this.newsid}) : super(key: key);
  @override
  _MyDiscussionPage createState() => _MyDiscussionPage(allDiscussion, newsid);
}

class _MyDiscussionPage extends State<Discussion> {
  bool isDataLoaded = false;
  List<dynamic> allDiscussionIds;
  List<dynamic> allDiscussions;
  String newsid;
  _MyDiscussionPage(this.allDiscussionIds, this.newsid);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    allDiscussions = new List<dynamic>();
    refreshPage();
  }

  void refreshPage() async {
    setState(() {
      isDataLoaded = false;
    });
    dynamic latestDiscussions = await FetchNews.getNewsById(newsid);
      print(latestDiscussions['discussions']);
    allDiscussionIds = latestDiscussions['discussions'];
    allDiscussions.clear();
    getDiscussion();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xFF957AFF),
            onPressed: () {
              Navigator.pop(context,allDiscussionIds);
            }),
            actions: [
                    IconButton(icon: Icon(Icons.refresh),color: Color(0xFF957AFF), onPressed: (){refreshPage();})
                  ],
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Color(0xFF957AFF),
            ),
        title: Text("Discussion"),
        backgroundColor: Colors.white24,
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddDiscussion(
                                    newsid: newsid,
                                  ))).then((value) {
                        if (value) {
                          print(value);
                          refreshPage();
                        }
                      });
                    },
                    elevation: 25.5,
                    child:Icon(Icons.add,size: 35, color:Colors.white,),
                    tooltip: 'Add Discussion',
                    backgroundColor: Color(0XFF67FDA7),
                  ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10.0),
            child: loadWidgetWhenDataAppears(context),
          ))
        ],
      )),
    ));
  }

  Widget loadWidgetWhenDataAppears(BuildContext context) {
    if (isDataLoaded && allDiscussions != null && allDiscussions.length > 0) {
      return createDiscussionList(context);
    } else if(isDataLoaded && allDiscussions.length<=0){
        return Center(child: Text("No Discussion"),);
    }else {
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

  Widget createDiscussionList(BuildContext context) {
    return ListView.builder(
        itemCount: allDiscussionIds.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailDiscussion(
                            Discussion: allDiscussions[index]['data'],
                            discussionId: allDiscussionIds[index],
                          ))).then((value) {
                            if(value){
                              refreshPage();
                            }
                          });
            },
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20.0,
                height: 200.0,
                child: Card(
                  color: Color(0xFF957AFF),
                  shadowColor: Color(0xFF957AFF),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  borderOnForeground: false,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                setCircleAvatar(allDiscussions[index]['data']
                                            ['createdBy']['userImage'] ==
                                        null
                                    ? ""
                                    : allDiscussions[index]['data']['createdBy']
                                        ['userImage']),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                setName(allDiscussions[index]['data']
                                    ['createdBy']['userDisplayName']),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          margin: EdgeInsets.only(top: 40.0),
                          width: MediaQuery.of(context).size.width - 20.0,
                          child: setDiscussionContent(
                              allDiscussions[index]['data']['title'])),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: setCommentButton(allDiscussions[index]
                                      ['data']['comments']
                                  .length),
                            ),
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: setViewButton(),
                            // )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height,
                      //   width: 8.0,
                      //   child: Container(
                      //     padding: EdgeInsets.only(top:100),
                      //     color: Colors.redAccent,
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget setCircleAvatar(String imageURL) {
    return Padding(
      padding: EdgeInsets.all(10),
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
      heightFactor: 1.8,
      alignment: Alignment.centerLeft,
      child: RichText(
          text: TextSpan(
              text: name,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'PoppinsRegular',
                  color: Colors.white,
                  fontSize: 20))),
    );
  }

  Widget setDiscussionContent(String content) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: RichText(
          text: TextSpan(
              text: content,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'PoppinsLight',
                  color: Colors.white,
                  fontSize: 20))),
    );
  }

  Widget setCommentButton(int commentLength) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Icon(Icons.chat_bubble_outline, color: Colors.white,)
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0,bottom: 10),
            child: RichText(
                text: TextSpan(
                    text: "" + commentLength.toString(),
                    style: TextStyle(fontSize: 22.0, fontFamily: "PoppinsRegular",
                        fontWeight: FontWeight.w200, color: Colors.white))),
          )
        ],
      ),
    );
  }

  Widget setViewButton() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        text: "View",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black))),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          )
        ],
      ),
    );
  }

  void getDiscussion() async {
    for (var i = 0; i < allDiscussionIds.length; i++) {
      var discussion =
          await FetchDiscussion.getAllDiscussions(allDiscussionIds[i]);
      allDiscussions.add(discussion);
    }
    setState(() {
      isDataLoaded = true;
    });
  }
}
