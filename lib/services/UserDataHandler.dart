import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataHandler {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  UserDataHandler({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  CollectionReference get _userDataCollection =>
      _firestore.collection('userdata');

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  Future<void> createUserData(Map<String, dynamic> data) async {
    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }
    await _userDataCollection.doc(currentUserId).set(data);
  }

  Future<DocumentSnapshot> readUserData() async {
    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }
    return await _userDataCollection.doc(currentUserId).get();
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }
    await _userDataCollection.doc(currentUserId).update(data);
  }

  Future<void> deleteUserData() async {
    if (currentUserId == null) {
      throw Exception('User is not authenticated');
    }
    await _userDataCollection.doc(currentUserId).delete();
  }
}
