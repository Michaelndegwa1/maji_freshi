import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Verify Phone Number
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android only: Auto-resolution
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  // Sign in with OTP
  Future<UserCredential> signInWithOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Create or Update User in Firestore
  Future<void> saveUserToFirestore({
    required User user,
    String? name,
    String? email,
  }) async {
    final userDoc = _firestore.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new user
      await userDoc.set({
        'uid': user.uid,
        'phoneNumber': user.phoneNumber,
        'name': name ?? '',
        'email': email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'customer', // Default role
      });
    } else {
      // Update existing user if new info provided
      Map<String, dynamic> updates = {};
      if (name != null && name.isNotEmpty) updates['name'] = name;
      if (email != null && email.isNotEmpty) updates['email'] = email;

      if (updates.isNotEmpty) {
        await userDoc.update(updates);
      }
    }
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
