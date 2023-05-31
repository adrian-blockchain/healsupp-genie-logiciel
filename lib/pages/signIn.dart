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
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.blueGrey,
      ),

      body: Container(
        width: double.infinity,
        height: 350,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(64),
              bottomRight: Radius.circular(64),
            ),
          ),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.green,
              Colors.greenAccent,
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 46.0, left: 20.0),
          child: Text(
            'Let s know each other',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: 36,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', width: 200, height: 200,),
            SignInButton(
              Buttons.Google,
              onPressed: (){
                _login();
              },
            ),
          ],
        ),
      ),
    );
  }
}