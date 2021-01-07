import 'package:badee_task/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:badee_task/helper/app_config.dart' as config;
class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.Colors().scaffoldColor(1.0),
      body: Container(margin: EdgeInsets.symmetric(horizontal: config.App(context).appWidth(10.0)),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //We take the image from the assets
            Image.asset(
              'images/blogo.png',
              height: config.App(context).appHeight(20.0),
            ),
            SizedBox(
              height: config.App(context).appHeight(5.0),
            ),
            //Texts and Styling of them
            Text(
              'Welcome to BTS !',
              textAlign: TextAlign.center,
              style: TextStyle(color: config.Colors().mainColor(1.0), fontSize: 28),
            ),
            SizedBox(height: config.App(context).appHeight(5.0)),
            Text(
              'I hope to be part of your flutter development team',
              textAlign: TextAlign.center,
              style: TextStyle(color: config.Colors().mainColor(1.0), fontSize: 16),
            ),
            SizedBox(
              height: config.App(context).appHeight(5.0),
            ),
            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
            MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
               Navigator.push(context,
                   MaterialPageRoute(builder: (_) => Login()));
              },
              color: config.Colors().accentColor(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Get Started',
                      style: TextStyle(color: config.Colors().scaffoldColor(1.0), fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: config.Colors().secondColor(1.0),
            )
          ],
        ),
      ),
    );
  }
}
