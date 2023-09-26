import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petkub2/customer/edit_data.dart';
import 'package:petkub2/login.dart';

import '../All data dog/dog_first.dart';

class MyProfileUsers extends StatefulWidget {
  const MyProfileUsers({Key? key}) : super(key: key);

  @override
  State<MyProfileUsers> createState() => _MyProfileUsersState();
}

class _MyProfileUsersState extends State<MyProfileUsers> {
  final currrenUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('customer');
  //final favoriteCollection = FirebaseFirestore.instance.collection('customer');
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void signOutGoogle() async {
    await _googleSignIn.signOut();
    // ignore: avoid_print
    print("User Sign Out");
  }

  @override
  void initState() {
    //เป็นฟังก์ชั่นแรกที่ทำงานเมื่อเข้ามาหน้านี้

    checkFavorite();
    super.initState();
  }

  Future<List<DocumentSnapshot>> getFavoriteDogs() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    CollectionReference favoriteCollection =
        FirebaseFirestore.instance.collection('customer');
    QuerySnapshot querySnapshot = await favoriteCollection
        .doc(currentUserEmail)
        .collection('favorite dog')
        .get();
    return querySnapshot.docs;
  }

  Future<void> checkFavorite() async {
    // ignore: avoid_print
    print('check');
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference favoriteCollection =
        FirebaseFirestore.instance.collection('customer');
    //DocumentSnapshot snapshot = await widget.dog.get();
    //Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    // Check if the dog is already in the favorite list
    // ignore: unused_local_variable
    QuerySnapshot querySnapshot = await favoriteCollection
        .doc(currentUser!.email)
        .collection('favorite dog')
        .get();
    setState(() {});
    // print(querySnapshot.docs[0].data());
    // print('end');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(83, 129, 36, 1),
          title: const Text('ข้อมูลส่วนตัว'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('customer')
              .doc(currrenUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //เรียกใช้ Field ใน Collection users
              final customerData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color.fromRGBO(159, 203, 114, 1),
                        child: CircleAvatar(
                            radius: 46,
                            backgroundImage:
                                NetworkImage(customerData['image'])),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currrenUser.displayName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currrenUser.email!,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(229, 227, 227, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditDataCustomer()));
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.black),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            signOutGoogle();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const MyLogIn();
                            }), ModalRoute.withName('/'));
                          },
                          child: const Text(
                            'Log out',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('customer')
                            .doc(currrenUser.email)
                            .collection('favorite dog')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('ไม่มีข้อมูลสุนัขที่บันทึกไว้'),
                                ],
                              ),
                            );
                          }
                          final dogs = snapshot.data!.docs;

                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: GridView.builder(
                              reverse: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.85,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10),
                              itemCount: dogs.length,
                              itemBuilder: (context, index) {
                                final document = dogs[index];
                                final idDog = document['id_dog'] ?? '';
                                final species = document['species'] ?? '';
                                final sex = document['sex'] ?? '';

                                final price = document['price'] ?? '';
                                final status = document['status'] ?? '';
                                bool isSoldOut = status == 'มีบ้านแล้ว';
                                final imageprofile =
                                    document['profileImage'] ?? '';

                                return InkWell(
                                  onTap: () {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection('dog')
                                            .doc(idDog);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyProfileDog(
                                                dog: documentReference)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        if (isSoldOut)
                                          Positioned(
                                              left: 7,
                                              child: Image.asset(
                                                'images/sold.png',
                                                height: 35,
                                              )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 45,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        159, 203, 114, 1),
                                                child: CircleAvatar(
                                                  radius: 43,
                                                  backgroundImage: NetworkImage(
                                                      imageprofile),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('$status : $idDog')
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '$species | $sex',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '฿ $price',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                  ),
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
        ));
  }
}
