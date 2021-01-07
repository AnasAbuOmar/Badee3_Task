import 'package:badee_task/pages/home.dart';

import 'package:flutter/material.dart';
import 'package:badee_task/pages/get_started.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? GetStarted() : Home(),
  ));
}
