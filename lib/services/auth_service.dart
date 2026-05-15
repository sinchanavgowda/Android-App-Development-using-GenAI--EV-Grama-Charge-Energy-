import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<String> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {

    try {

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "name": name,
        "email": email,
        "role": role,
      });

      return "success";

    } on FirebaseAuthException catch (e) {
      return e.message ?? "Registration Failed";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {

    try {

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";

    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login Failed";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}