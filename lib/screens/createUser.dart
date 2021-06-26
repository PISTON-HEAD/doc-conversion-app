import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_conversion/auth/authenticate.dart';
import 'package:doc_conversion/custom/customUses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userCreater extends StatefulWidget {
  final UsersMail;

  const userCreater({Key key, this.UsersMail}) : super(key: key);
  @override
  _userCreaterState createState() => _userCreaterState(UsersMail);
}

class _userCreaterState extends State<userCreater> {
  final usersMail;
  _userCreaterState(this.usersMail);

  final formkey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController keyPassController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool seePassword = true;
  IconData passwordVisibility = Icons.visibility_off;
  String errorMsg;
  bool error = false;


  SignUp() {
    if (formkey.currentState.validate()) {
      print("Textfield validation true");
      signUp(usersMail, passController.text , userNameController.text).then((value) async {
        if (value != null) {
          setState(() {
            error = true;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("Error message : $errorMsg");
                //sho the error msg
              }
            }
            //errorMsg = value;
          });
        } else {
          setState(() {
            error =!true;
          });
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          print(sharedPreferences.getString("LoggedIn"));
          print("next screen");
          //Navigator.push(context, MaterialPageRoute(builder: (context) =>));
        }
      });
    }
  }

  LogIn() {
    if (formkey.currentState.validate()) {
      logInUser(emailController.text, passController.text).then((value) async {
        if (value != null) {
          setState(() {
            error = true;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("the error message $i  $errorMsg");
              }
            }
          });
        } else {
          FirebaseFirestore.instance
              .collection("Ordinary_Users")
              .doc(firebaseAuth.currentUser.uid)
              .update({
            "password": passController.text,
          });
          setState(() {
            error =!true;
          });
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          print(sharedPreferences.getString("LoggedIn"));
          print("NextScreen..");
          //Navigator.push(context, MaterialPageRoute(builder: (context) => profile_Screen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: usersMail.toString().length != 0 ? appBar_Main(context, "SignUp User", Colors.black):appBar_Main(context, "Log In", Colors.lightGreen[900]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            error?SizedBox(
              child: Text("$errorMsg"),
            ):SizedBox(),
            Form(
              key: formkey,
              child: Column(
                children: [
                  usersMail.toString().length != 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.yellowAccent)),
                          child: TextFormField(
                            cursorColor: Colors.limeAccent,
                            cursorWidth: 4,
                            validator: (value) {
                              return value.toString().length <= 4
                                  ? "Minimum character required is 5"
                                  : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: userNameController,
                            style: textFieldStyle,
                            decoration: textInputDecoration(
                                "username", Icons.person_rounded),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.yellowAccent)),
                          child: TextFormField(
                            cursorColor: Colors.limeAccent,
                            cursorWidth: 4,
                            validator: (value) {
                              if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return null;
                              } else {
                                return "Enter valid Email";
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            style: textFieldStyle,
                            decoration: textInputDecoration(
                                "Email", Icons.alternate_email),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.blue)),
                    child: TextFormField(
                      cursorColor: Colors.limeAccent,
                      cursorWidth: 4,
                      obscureText: seePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String val = value.toString().toLowerCase();
                        int charCounter = 0;
                        if (value.isEmpty || value.length < 8) {
                          return "character required is 8";
                        } else {
                          for (int i = 0; i < value.length; i++) {
                            if (val.codeUnitAt(i) >= 97 &&
                                val.codeUnitAt(i) <= 122) {
                            } else {
                              charCounter++;
                            }
                          }
                          return charCounter != 0
                              ? null
                              : "Enter characters other than alphabets, ex: 1,/,-...";
                        }
                      },
                      controller: passController,
                      style: textFieldStyle,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "password",
                        labelText: "password",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amberAccent,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              if (seePassword == true) {
                                passwordVisibility = Icons.visibility;
                                seePassword = !true;
                              } else {
                                passwordVisibility = Icons.visibility_off;
                                seePassword = true;
                              }
                            });
                          },
                        ),
                        hintStyle: textFieldStyle,
                        labelStyle: textFieldStyle,
                        errorStyle: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          FontAwesomeIcons.key,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  usersMail.toString().length != 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.blue)),
                          child: TextFormField(
                            cursorColor: Colors.limeAccent,
                            cursorWidth: 4,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value == passController.text
                                  ? null
                                  : "passwords don't match";
                            },
                            controller: keyPassController,
                            style: textFieldStyle,
                            decoration: textInputDecoration(
                                "password conirmation",
                                Icons.admin_panel_settings_rounded),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            MaterialButton(
                child: Text(
                  usersMail.toString().length==0?"Log In":"SignUp",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  usersMail.toString().length==0?LogIn():SignUp();
                  print("$usersMail");
                }),
          ],
        ),
      ),
    );
  }
}
