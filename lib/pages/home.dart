import 'package:badee_task/models/post.dart';
import 'package:badee_task/pages/details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/post_service.dart';
import '../helper/app_config.dart' as config;
import '../pages/login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PostService _postService = PostService();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";

  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }
  @override
  void initState() {
    _postService.fetchPosts();
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.Colors().mainColor(1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Owners'),
        centerTitle: true,
        leading: IconButton(
          icon: Text('Logout',style: TextStyle(fontSize: 12),),
          onPressed: (){
            logOut(context);
            signOutGoogle();
          },
        ),
      ),
      body: FutureBuilder(
          future: _postService.fetchPosts(),
          builder: (BuildContext context, AsyncSnapshot<Posts> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data.data[i].owner.picture),
                        ),
                        title: Text(
                          '${snapshot.data.data[i].owner.title.toString().replaceAll('Title.', '')} . ${snapshot.data.data[i].owner.firstName} ${snapshot.data.data[i].owner.lastName}',
                          style: GoogleFonts.abel(
                              fontSize: config.App(context).appHeight(2.5),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${snapshot.data.data[i].owner.email}',
                          style: GoogleFonts.abel(
                              fontSize: config.App(context).appHeight(1.9),
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(Icons.east_sharp),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Details(
                                        id: snapshot.data.data[i].id,
                                      )));
                        },
                      ),
                    );
                  });
            } //snapshot.data.data[i].owner.firstName
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
  Future logOut(BuildContext context)async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');

    Fluttertoast.showToast(
        msg: "Logout Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: config.Colors().scaffoldColor(1.0),
        textColor: config.Colors().mainColor(1.0),
        fontSize: 16.0
    );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(),),);
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }
}
