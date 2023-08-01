import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petkub2/user_inputData.dart';

import 'bottom_navigator.dart';

class MyLogIn extends StatefulWidget {
  const MyLogIn({super.key});

  @override
  State<MyLogIn> createState() => _MyLogInState();
}

class _MyLogInState extends State<MyLogIn> {
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the sign-in was successful
      if (userCredential.user != null) {
        // ignore: avoid_print
        print(userCredential.user!.email);
        // ignore: avoid_print, use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const InputDataForUser(),
          ),
        );
      }
    } catch (e) {
      // Handle sign-in errors here
      // ignore: avoid_print
      print('Error signing in: $e');
    }
  }

  Future<void> checkUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print(user.email);
      final userDocRef =
          FirebaseFirestore.instance.collection('customer').doc(user.uid);

      // ดึงข้อมูลผู้ใช้ล่าสุดจาก Firestore
      final userDataSnapshot = await userDocRef.get();
      final userData = userDataSnapshot.data();

      if (userData != null) {
        // มีข้อมูลผู้ใช้ในเอกสาร
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyNavigator()),
        );
      } else {
        // ไม่มีข้อมูลผู้ใช้ในเอกสาร
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputDataForUser()),
        );
      }
    } else {
      // ไม่ได้เข้าสู่ระบบ
      // ดำเนินการอื่น ๆ ตามที่คุณต้องการ
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
              'images/logo.png',
              height: 200,
            ),
            const Text(
              'ยินดีต้อนรับสู่',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Babykwan's Dog house",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => signInWithGoogle(),
              child: const Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }

  /* Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternerProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, 'Check your Internet connection', Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
        } else {}
      });
    }
  }*/
}
