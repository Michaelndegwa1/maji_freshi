import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google User Credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Save user to Firestore
      if (userCredential.user != null) {
        await saveUserToFirestore(
          user: userCredential.user!,
          name: googleUser.displayName,
          email: googleUser.email,
        );
      }

      return userCredential;
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      rethrow;
    }
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
        'name': name ?? user.displayName ?? '',
        'email': email ?? user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'customer', // Default role
      });
    } else {
      // Update existing user if new info provided
      Map<String, dynamic> updates = {};
      if (name != null && name.isNotEmpty) updates['name'] = name;
      if (email != null && email.isNotEmpty) updates['email'] = email;

      // Also update email/name if they were missing before but are available now (e.g. linking google)
      final data = docSnapshot.data();
      if (data != null) {
        if ((data['name'] == null || data['name'].isEmpty) &&
            (user.displayName != null && user.displayName!.isNotEmpty)) {
          updates['name'] = user.displayName;
        }
        if ((data['email'] == null || data['email'].isEmpty) &&
            (user.email != null && user.email!.isNotEmpty)) {
          updates['email'] = user.email;
        }
      }

      if (updates.isNotEmpty) {
        await userDoc.update(updates);
      }
    }
  }

  // Get Current User
  User? get currentUser => _auth.currentUser;

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
