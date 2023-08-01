import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petkub2/customer/edit_data.dart';
import 'package:petkub2/login.dart';

class UserCollectionData extends StatefulWidget {
  const UserCollectionData({super.key});

  @override
  State<UserCollectionData> createState() => _UserCollectionDataState();
}

class _UserCollectionDataState extends State<UserCollectionData> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signOutGoogle() async {
    await _googleSignIn.signOut();
    // ignore: avoid_print
    print("User Sign Out");
  }

  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('customer')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final customerData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, bottom: 15, top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditDataCustomer()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          dataprivate('เพศ', customerData['sex']),
                          dataprivate('วันเกิด', customerData['date_of_birth']),
                          dataprivate('รายได้', customerData['income']),
                          dataprivate('สถานะ', customerData['status']),
                          dataprivate('ประกอบอาชีพ', customerData['career']),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(159, 203, 114, 1),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return const MyLogIn();
                          }), ModalRoute.withName('/'));
                        },
                        child: const Text('Log out')),
                  ],
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget dataprivate(String title, String inputtitle) => Container(
      // height: 45,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(159, 203, 114, 1)))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('$title  :   ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Expanded(
              child: Text(
                inputtitle,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ));
}
