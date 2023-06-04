import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/CurrentUser.dart';
import 'CreateProfil.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoggedIN = false;
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
  );

  _login() async {
    print("Google Sign");
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      if (user != null) {
        CurrentUser.setLoginStatus(true);

        // Check if user data exists in Firestore
        final userDataRef = FirebaseFirestore.instance
            .collection('userdata')
            .doc(user.uid);
        final DocumentSnapshot userData = await userDataRef.get();

        if (userData.exists) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  CreatePage()),
                  (route) => false);
        }
      }
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration:const BoxDecoration(
              image : DecorationImage(
                image: AssetImage('assets/intro_page.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child:Image.asset("assets/logo.png") ,
          ),
          Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30)
              ),
              alignment: Alignment.bottomCenter,

              height: 50,
              child:SignInButton(
                Buttons.Google,
                onPressed: (){
                  _login();
                },
              ),
            ),
          ),



        ],
      ),
      );
  }
}