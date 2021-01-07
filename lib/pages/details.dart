import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:badee_task/models/mark_as_read.dart';
import 'package:badee_task/models/post_id.dart';
import 'package:badee_task/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:badee_task/helper/app_config.dart' as config;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();

  final String id;

  Details({@required this.id});
}

class _DetailsState extends State<Details> {
  PostService _postService = PostService();
  Color bgColor = config.Colors().mainColor(0.8);
  String markAsReadButtonText = 'Mark as Read';
  List<MarkAsRead> list = new List<MarkAsRead>();
  SharedPreferences sharedPreferences;
  List<String> listString;

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void loadData() {
    listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString
          .map((item) => MarkAsRead.fromMap(json.decode(item)))
          .toList();
      print('load data $listString');
      if (listString.toString().contains(widget.id)) {
        bgColor = config.Colors().accentColor(0.8);
        markAsReadButtonText = 'Done';
      }
      setState(() {});
    }
  }

  void addItem(MarkAsRead item) {
    // Insert an item into the top of our list, on index zero
    if (markAsReadButtonText != 'Done') {
      list.insert(0, item);
      saveData();
      setState(() {
        bgColor = config.Colors().accentColor(0.8);
        markAsReadButtonText = 'Done';
      });
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', stringList);
  }

  @override
  void initState() {
    _postService.fetchPostsByID(widget.id.toString());
    loadSharedPreferencesAndData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0.1,
        title: Text('Details'),
        backgroundColor: config.Colors().mainColor(1.0),
        actions: <Widget>[],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Material(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  elevation: 0.0,
                  child: MaterialButton(
                    onPressed: () {
                      MarkAsRead item = MarkAsRead();
                      item.id = widget.id;

                      addItem(item);
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(
                      markAsReadButtonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: config.Colors().mainColor(1.0),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  )),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: _postService.fetchPostsByID(widget.id),
          builder: (BuildContext context, AsyncSnapshot<PostsId> snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: config.Colors().mainColor(0.9),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.network(
                          snapshot.data.image,
                          height: 360,
                          width: 360,
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                // Box decoration takes a gradient
                                gradient: LinearGradient(
                                  // Where the linear gradient begins and ends
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  // Add one stop for each color. Stops should increase from 0 to 1
                                  colors: [
                                    // Colors are easy thanks to Flutter's Colors class.3
                                    config.Colors().mainColor(0.7),
                                    config.Colors().mainColor(0.5),
                                    config.Colors().mainColor(0.07),
                                    config.Colors().mainColor(0.05),
                                    config.Colors().mainColor(0.025),
                                  ],
                                ),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container())),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: 360,
                              decoration: BoxDecoration(
                                // Box decoration takes a gradient
                                gradient: LinearGradient(
                                  // Where the linear gradient begins and ends
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  // Add one stop for each color. Stops should increase from 0 to 1
                                  colors: [
                                    // Colors are easy thanks to Flutter's Colors class.
                                    config.Colors().mainColor(0.8),
                                    config.Colors().mainColor(0.6),
                                    config.Colors().mainColor(0.6),
                                    config.Colors().mainColor(0.4),
                                    config.Colors().mainColor(0.07),
                                    config.Colors().mainColor(0.05),
                                    config.Colors().mainColor(0.025),
                                  ],
                                ),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container())),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      snapshot.data.tags.first,
                                      style: GoogleFonts.abel(
                                          color: config.Colors()
                                              .scaffoldColor(1.0),
                                          fontSize: config.App(context)
                                              .appHeight(3.0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Like : ${snapshot.data.likes.toString()}',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.abel(
                                              color: config.Colors()
                                                  .scaffoldColor(1.0),
                                              fontSize: config.App(context)
                                                  .appHeight(3.0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${snapshot.data.owner.title}. ${snapshot.data.owner.firstName} ${snapshot.data.owner.lastName}',
                                style: GoogleFonts.abel(
                                    color: config.Colors().scaffoldColor(1.0),
                                    fontSize:
                                        config.App(context).appHeight(2.0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(snapshot.data.owner.picture),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: config.Colors().mainColor(1.0),
                                  offset: Offset(2, 5),
                                  blurRadius: 10)
                            ]),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              //select color
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Tags: ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        '#${snapshot.data.tags.first}  #${snapshot.data.tags[1]} #${snapshot.data.tags.last}',
                                        style: TextStyle(
                                            color: config.Colors()
                                                .secondColor(1.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //select size
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Publish date: ',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('${formatDate(snapshot.data.publishDate, [yyyy, '-', mm, '-', dd])}  ${formatDate(snapshot.data.publishDate, [hh, ':', nn, ':', ss, ' ', am])}'
                                          ,
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text('Text: ',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Container(
                                        width:
                                            config.App(context).appWidth(65.0),
                                        child: Column(
                                          children: [
                                            Text(snapshot.data.text,
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              Divider(
                                color: Colors.white,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text('Link: ',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            child: new Text(
                                              snapshot.data.link != null
                                                  ? 'Open Browser'
                                                  : '',
                                              style: GoogleFonts.abel(
                                                  color: config.Colors()
                                                      .accentColor(1.0),
                                                  fontSize: config.App(context)
                                                      .appHeight(3.0),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onTap: () =>
                                                launch(snapshot.data.link),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
    ;
  }
}
