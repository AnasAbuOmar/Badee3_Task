import 'package:badee_task/pages/home.dart';
import 'package:badee_task/pages/register.dart';
import 'package:badee_task/widgets/custom_material_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:badee_task/helper/app_config.dart' as config;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool authSignedIn;
  String uid;
  String userEmail;
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: config.Colors().mainColor(1.0),
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign in to BTS and continue',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: config.Colors().secondColor(1.0), fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter your email and password below to continue to the Badee For Technical Solution !',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: 50,
                ),
                _buildEmailTextField(emailController, Icons.alternate_email,
                    'Email', 'Anas@gmail.com', TextInputType.emailAddress),
                SizedBox(height: 20),
                _buildPassTextField(passwordController, Icons.lock, 'Password',
                    '••••••••••••', TextInputType.text),
                SizedBox(height: 30),
                CustomMaterialButton(color: config.Colors().accentColor(1.0), text: 'Login', onPressed: () {
                  /*checkLogin();*/
                  signInWithEmailPassword(
                      emailController.text, passwordController.text)
                      .then((result) {
                    if (result != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return Home();
                          },
                        ),
                      );
                    }
                  });
                  /*signInWithEmailPassword(emailController.text, passwordController.text);*/
                }),

                SizedBox(height: 20),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                    signInWithGoogle().then((result) {
                      if (result != null) {
                        /*checkLogin();*/
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
                        );
                      }
                    });
                  },
                  color: config.Colors().secondColor(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 10),
                      Text('Sign-in using Google',
                          style: TextStyle(
                              color: config.Colors().mainColor(1.0),
                              fontSize: 16)),
                    ],
                  ),
                  textColor: config.Colors().mainColor(1.0),
                ),
                SizedBox(height: 70),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterButtons(
                      context, 'I don\'t have an account', () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Register()));
                  }),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterButtons(BuildContext ctx, String txt, Function onPress) {
    return FlatButton(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(txt,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  color: config.Colors().scaffoldColor(1.0),
                  fontSize: config.App(ctx).appHeight(2.0),
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: config.App(ctx).appWidth(1.5),
          ),
          Icon(
            Icons.help_rounded,
            color: config.Colors().scaffoldColor(1.0),
          )
        ],
      ),
    );
  }

  _buildEmailTextField(TextEditingController controller, IconData icon,
      String labelText, String hintText, TextInputType tit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: config.Colors().scaffoldColor(0.5),
          border: Border.all(color: config.Colors().accentColor(0.5))),
      child: TextFormField(
        keyboardType: tit,
        controller: controller,
        style: TextStyle(color: config.Colors().scaffoldColor(1.0)),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: config.Colors().scaffoldColor(1.0)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: config.Colors().scaffoldColor(1.0)),
            icon: Icon(
              icon,
              color: config.Colors().scaffoldColor(1.0),
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }

  _buildPassTextField(TextEditingController controller, IconData icon,
      String labelText, String hintText, TextInputType tit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: config.Colors().scaffoldColor(0.5),
          border: Border.all(color: config.Colors().accentColor(0.5))),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          trailing: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  if (hidePass == true)
                    hidePass = false;
                  else
                    hidePass = true;
                });
              }),
          title: TextFormField(
            obscureText: hidePass,
            keyboardType: tit,
            controller: controller,
            style: TextStyle(color: config.Colors().scaffoldColor(1.0)),
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: config.Colors().scaffoldColor(1.0)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                labelText: labelText,
                labelStyle:
                    TextStyle(color: config.Colors().scaffoldColor(1.0)),
                icon: Icon(
                  icon,
                  color: config.Colors().scaffoldColor(1.0),
                ),
                // prefix: Icon(icon),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }



  Future<String> signInWithEmailPassword(String email, String password) async {
    // Initialize Firebase
    await Firebase.initializeApp();

    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User user = userCredential.user;

    if (user != null) {
      // checking if uid or email is null
      assert(user.uid != null);
      assert(user.email != null);

      uid = user.uid;
      userEmail = user.email;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', emailController.text);
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: config.Colors().scaffoldColor(1.0),
          textColor: config.Colors().mainColor(1.0),
          fontSize: 16.0
      );
      return 'Successfully logged in, User UID: ${user.uid}';
    } else{
      Fluttertoast.showToast(
          msg: "Username & Password Invalid!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: config.Colors().scaffoldColor(1.0),
          textColor: config.Colors().mainColor(1.0),
          fontSize: 16.0
      );
    }

    return null;
  }



}
