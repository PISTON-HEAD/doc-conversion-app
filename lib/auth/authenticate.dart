import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future signUp(String email, String pass , String userName)async{
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    final userIn = credential.user;
    final logger = (await FirebaseFirestore.instance.collectionGroup("Users").where("id",isEqualTo: userIn.uid).get()).docs;
    if(logger.isEmpty){
      print("Creating new user proile");
      userIn.updateDisplayName(userName);
      //User.updatePhotoURL(user.photoURL);
      FirebaseFirestore.instance.collection("Users").doc(userIn.uid).set({
        "Name":userName,
        "Email":email,
        "Password":pass,
        "Recipes":0,
        "Profile Photo":firebaseAuth.currentUser.photoURL,
        "Created Time":DateTime.now().microsecondsSinceEpoch,
        "Last SignedIn":DateTime.now().toString().substring(0,16),
        "id":userIn.uid,
      });
      sharedPreferences.setString("id",userIn.uid);
      sharedPreferences.setString("Name",userName);
      sharedPreferences.setString("Email",email);
      sharedPreferences.setString("Password",pass);
      sharedPreferences.setString("Profile Photo",userIn.photoURL);
      sharedPreferences.setInt("Recipes", 0);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(error){
    print("error found: $error");
    if(error.toString().length > 10){
      print("true");
      return error;
    }else{
      return null;
    }
  }
}

Future logInUser(String email ,String password)async{
  try{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("Ordinary_Users").where("id",isEqualTo: fireUser.uid).get()).docs;
    if(logger.isNotEmpty){
      print("Old User Signing...");
      sharedPreferences.setString("id",logger[0]["id"]);
      sharedPreferences.setString("Name",logger[0]["Name"]);
      sharedPreferences.setString("Email",logger[0]["Email"]);
      sharedPreferences.setString("Password",logger[0]["Password"]);
      sharedPreferences.setString("Profile Photo",logger[0]["Profile Photo"]);
      sharedPreferences.setInt("Recipes", logger[0]["Recipes"]);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(e){
    print("this is error $e");
    if(e.toString().length > 10){
      print("true");
      return e.toString();
    }else{
      return null;
    }
  }
}