import 'dart:ui';

import 'package:doc_conversion/custom/customUses.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'createUser.dart';

class MailAuth extends StatefulWidget {
  @override
  _MailAuthState createState() => _MailAuthState();
}

class _MailAuthState extends State<MailAuth> {
  @override
  Widget build(BuildContext context) {
    TextEditingController mailEditingController = new TextEditingController();
    TextEditingController OTPEditingController =new TextEditingController();

    final formKey = GlobalKey<FormState>();
    OTPsender() async {
      EmailAuth.sessionName = "Email Auth";
      print("OTP SENT");
      var response =
          EmailAuth.sendOtp(receiverMail: mailEditingController.text);
      print(response);
      response.then((value) {
        print("The response $response");
      });
    }


    return Scaffold(
        appBar: appBar_Main(context, "Welcome", Colors.black),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellowAccent),
                        color: Colors.black),
                    child: TextFormField(
                      style: textFieldStyle,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: mailEditingController,
                      validator: (value) {
                        if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        } else {
                          return "Enter valid Email";
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        hintText: "Email",
                        labelText: "Email",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.greenAccent,
                            width: 3.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.amberAccent,
                          ),
                        ),
                        hintStyle: textFieldStyle,
                        labelStyle: textFieldStyle,
                        errorStyle: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Colors.white,
                        ),
                        suffix: TextButton(
                          onPressed: () {
                            OTPsender();
                          },
                          child: Text(
                            "Send OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellowAccent),
                        color: Colors.black),
                    child: TextFormField(
                      style: textFieldStyle,
                      controller: OTPEditingController,
                        obscureText: true,
                        //keyboardType: Keyboard,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return value.length > 2 ? null : "Enter a valid OTP";
                        },
                        decoration: textInputDecoration(
                            "OTP", Icons.admin_panel_settings_rounded)),
                  ),
                  SizedBox(height: 20,),
                  MaterialButton(
                    color: Colors.teal,
                      child: Text("Validate",),
                      onPressed: (){
                        if(formKey.currentState.validate()){
                          var reaction = EmailAuth.validate(receiverMail: mailEditingController.text, userOTP: OTPEditingController.text);
                          if(reaction){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => userCreater(UsersMail: mailEditingController.text,)));
                          }else{print("Validation ailed");}
                        }
                      }
                      ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Already have an Account ?"),
                      TextButton(
                        child:Text("Log In",style: TextStyle(decoration: TextDecoration.underline),),
                        onPressed: (){
                          mailEditingController.text ="";
                          Navigator.push(context, MaterialPageRoute(builder: (context) => userCreater(UsersMail: mailEditingController.text,)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
