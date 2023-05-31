import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../services/CurrentUser.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Map<String, dynamic>? _userData;

  Future<void> getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _userData = userData.data();
    });
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser == null) {
        _handleSignOut();
      }
    });
    getUserData();

    _googleSignIn.signInSilently();
  }


  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();

    CurrentUser.setLoginStatus(false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false,
    );
  }


  Future<void> _deleteAccount() async {
    // Delete personal data
    await FirebaseFirestore.instance
        .collection('userdata')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    // Disconnect from Google SignIn
    _googleSignIn.disconnect();

    // Delete Firebase user
    await FirebaseAuth.instance.currentUser!.delete();

    // Set login status to false
    CurrentUser.setLoginStatus(false);
    CurrentUser.setCreationAccountStatus(false);

    // Navigate to the home page and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Page'),
        actions: [
          IconButton(
            onPressed: _deleteAccount,
            icon: Icon(Icons.delete, color: Colors.red,),
          ),
        ],
      ),
      body: Center(
        child: _currentUser == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_currentUser!.photoUrl!),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(
              _currentUser!.displayName!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _currentUser!.email,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            _userData == null
                ? CircularProgressIndicator()
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Age: ${_userData!['age']}   ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Weight: ${_userData!['weight']}   ',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Height: ${_userData!['height']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tes objectifs:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (_userData!['favorite'] != null)
                    ...(_userData!['favorite'] as List<dynamic>).map((item) {
                      return Text(
                        item.toString(),
                        style: TextStyle(fontSize: 16),
                      );
                    }).toList(),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Votre profil:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (_userData!['activity'] != null)
                    ...(_userData!['activity'] as List<dynamic>).map((item) {
                      return Text(
                        item.toString(),
                        style: TextStyle(fontSize: 16),
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _handleSignOut,
        child: const Text('Logout'),
      ),
    );
  }

}
