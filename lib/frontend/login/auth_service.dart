import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:simplex_chapter_x/backend/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<void> _addUserToFirestore(User user) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      UserModel newUser = UserModel(
        id: user.uid,
        email: user.email ?? '',
        profilePic: user.photoURL ?? '',
        name: user.displayName ?? '',
        pastEvents: [],
        compEvents: [],
        grade: 12,
        isExec: false,
        approved: true,
        openedAppSinceApproved: false,
        currentChapter: '',
        chapters: [],
        topicsSubscribed: [],
      );

      await UserModel.writeUser(newUser);
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final scaffoldContext = ScaffoldMessenger.of(context);
      final navigatorState = Navigator.of(context);

      final userCredential = await _auth.signInWithCredential(credential);

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      print(userCredential);

      String fullName;
      if (userDoc.exists) {
        fullName = userDoc.get('name') ?? '';
      } else {
        fullName =
            await _getFullNameSafely(context, userCredential.user!) ?? '';

        if (fullName.isNotEmpty) {
          UserModel newUser = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            profilePic: userCredential.user!.photoURL ?? '',
            name: fullName,
            pastEvents: [],
            compEvents: [],
            grade: 12,
            isExec: false,
            approved: true,
            openedAppSinceApproved: false,
            currentChapter: '',
            chapters: [],
            topicsSubscribed: [],
          );

          await UserModel.writeUser(newUser);
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');

      if (e.code == 'internal-error' &&
          e.message?.contains('DUPLICATE_RAW_ID') == true) {
        try {
          final currentUser = _auth.currentUser;
          if (currentUser != null) {
            return await _auth
                .signInWithCredential(GoogleAuthProvider.credential(
              accessToken: await currentUser.getIdToken(),
              idToken: await currentUser.getIdToken(),
            ));
          }
        } catch (signInError) {
          print('Error signing in with existing account: $signInError');
        }
      }

      return null;
    } catch (e) {
      print('Unexpected error signing in with Google: $e');
      return null;
    }
  }

  Future<String?> _getFullNameSafely(BuildContext context, User user) async {
    if (user.displayName != null && user.displayName!.contains(' ')) {
      return user.displayName;
    }

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final firstNameController = TextEditingController();
        final lastNameController = TextEditingController();

        if (user.displayName != null) {
          firstNameController.text = user.displayName!;
        }

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Complete Your Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                ),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                if (firstNameController.text.isNotEmpty &&
                    lastNameController.text.isNotEmpty) {
                  String fullName =
                      '${firstNameController.text} ${lastNameController.text}';
                  Navigator.of(dialogContext).pop(fullName);
                } else {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                        content: Text('Please enter both first and last name')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await _addUserToFirestore(userCredential.user!);
      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      print('Apple Sign-In Authorization Error:');
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error:');
      print('Error code: ${e.code}');
      print('Error message: ${e.message}');
    } catch (e) {
      print('Unexpected error during Apple Sign-In: $e');
    }
    return null;
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
