// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petkub2/user_input_data.dart';

import 'bottom_navigator.dart';

class MyLogIn extends StatefulWidget {
  const MyLogIn({super.key});

  @override
  State<MyLogIn> createState() => _MyLogInState();
}

class _MyLogInState extends State<MyLogIn> {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("customer");
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        final docSnapshot =
            await collectionRef.doc(userCredential.user!.email).get();

        if (docSnapshot.exists) {
          // Document already exists, navigate to MyNavigator directly

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyNavigator(),
            ),
          );
        } else {
          // Document doesn't exist, navigate to InputDataForUser
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const InputDataForUser(),
            ),
          );
        }
      }
    } catch (e) {
      // Handle sign-in errors here
      // ignore: avoid_print
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/soonak Logo.png',
              height: 180,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => signInWithGoogle(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 3),
                              blurRadius: 2,
                              color: Colors.grey.shade400)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.network(
                          'https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png',
                          height: 45,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'เข้าสู่ระบบด้วย Google',
                          style: TextStyle(
                              color: Color.fromRGBO(59, 89, 152, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
