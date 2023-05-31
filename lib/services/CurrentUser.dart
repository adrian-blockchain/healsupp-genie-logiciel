import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  static SharedPreferences? mypreferences;
  static const emailKey = 'emailKey';
  static const passwordKey = 'paswordKey';
  static const loginStatusKey = 'loginStatusKey';

  static Future<void> init() async {
    mypreferences = await SharedPreferences.getInstance();
  }



  static Future<bool?> setLoginStatus(bool status) async {
    mypreferences = await SharedPreferences.getInstance();

    return await mypreferences?.setBool(loginStatusKey, status);
  }

  static Future<bool?> setCreationAccountStatus(bool status) async {
    mypreferences = await SharedPreferences.getInstance();

    return await mypreferences?.setBool("creationAccountStatus", status);
  }

  static Future<bool?> getCreationAccountStatus(bool status) async {
    mypreferences = await SharedPreferences.getInstance();

    return mypreferences?.getBool("creationAccountStatus") ?? false;
  }


  static Future<bool> getUserLoginStatus() async {
    mypreferences = await SharedPreferences.getInstance();

    return mypreferences?.getBool(loginStatusKey) ?? false;
  }

  static Future<void> disconnect() async {
    // Log out from Firebase
    await FirebaseAuth.instance.signOut();

    // Set the login status to false
    await setLoginStatus(false);
  }
}