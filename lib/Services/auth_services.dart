import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth ;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthServices(this._firebaseAuth);

  bool isSigningIn = false;
  var user;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> loginWithGoogle () async {
    isSigningIn = true;
    user = await googleSignIn.signIn();
    String msg = 'Action aborted';
    if(user == null){
      isSigningIn = false;
      return msg;
    }else{
      try{
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        await _firebaseAuth.signInWithCredential(credential);
        isSigningIn = false;
        msg = 'In';
      } on FirebaseAuthException  catch(e) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            msg = 'This Account already exists with different Credentials!';
            break;
          case 'invalid-credential':
            msg = 'The Credentials are Invalid!';
            break;
          case 'operation-not-allowed':
            msg = 'This operation is not allowed!';
            break;
          case 'user-disabled':
            msg = 'This user has been disabled!';
            break;
          case 'user-not-found':
            msg = 'The User not found';
            break;
          case 'wrong-password':
            msg = 'This password is wrong!';
            break;
          case 'invalid-verification-code':
            msg = 'The verification code is wrong!';
            break;
          case 'invalid-verification-id':
            msg = 'The verification ID is wrong!';
            break;
        }
      }
      return msg;
    }
  }

  Future<String> signOut () async {
    String msg = 'null';
    try{
      if(user != null){
        await googleSignIn.disconnect();
      }
      await _firebaseAuth.signOut();
    }on PlatformException catch (e) {
      msg = e.message!;
    }
    return msg;
  }
}