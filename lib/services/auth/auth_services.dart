import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
//

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userSnapshot = await _fireStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      bool isAdmin = userSnapshot.get('isAdmin') ?? false;

      _fireStore.collection('users').doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
            'isAdmin': isAdmin,
          },
          SetOptions(
              merge: true)); // Use merge option to update only isAdmin field

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'isAdmin': false,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> logOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
