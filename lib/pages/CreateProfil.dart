import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:healsupp/components/CategoryQuestionPage.dart';
import 'package:healsupp/components/PreferenceQuestionPage.dart';
import 'package:healsupp/services/CurrentUser.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();





  sendToFirebase() async{

    // Show dialog with CircularProgressIndicator
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Center(
            child:CircularProgressIndicator(),
          )
        );
      },
    );





    Map<String, dynamic> data = {
      'age': _ageController.text,
      'weight': _weightController.text,
      'height': _heightController.text,
      'favorite':[],
      'activity': [],
      'shoppingList': []
    };

    CurrentUser.setCreationAccountStatus(true);

    await FirebaseFirestore.instance.collection('userdata').doc(FirebaseAuth.instance.currentUser!.uid).set(data);
    print("data created ");
    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PreferenceQuestionPage()),
            (route) => false);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create your Profile'),
        backgroundColor: Colors.green,

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              SizedBox(height: 16.0),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (in kg)',
                  hintText: 'Enter your weight',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (in cm)',
                  hintText: 'Enter your height',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: ()async {
                  await sendToFirebase();
                  },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
