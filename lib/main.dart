import 'package:doc_conversion/screens/emailAuth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  // String logger = sharedPreferences.getString("LoggedIn");
  // String id = sharedPreferences.getString("id");
  // print(logger);
  // print(id);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MailAuth(),
    );
  }
}