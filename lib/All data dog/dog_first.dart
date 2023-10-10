import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/All%20data%20dog/pedigree.dart';
import 'package:petkub2/All%20data%20dog/photo_ofdog.dart';
import 'package:petkub2/All%20data%20dog/vaccine_dog.dart';
import 'package:petkub2/bottom_navigator.dart';

import 'dataofdog.dart';

class MyProfileDog extends StatefulWidget {
  final DocumentReference dog;

  const MyProfileDog({Key? key, required this.dog}) : super(key: key);

  @override
  State<MyProfileDog> createState() => _MyProfileDogState();
}

class _MyProfileDogState extends State<MyProfileDog> {
  late Stream<DocumentSnapshot> documentStream;
  DocumentSnapshot? currentDocument;
  bool isFavorite = false;
  CollectionReference favoriteCollection =
      FirebaseFirestore.instance.collection('customer');
  QuerySnapshot? allDogsSnapshot;

  @override
  void initState() {
    //เป็นฟังก์ชั่นแรกที่ทำงานเมื่อเข้ามาหน้านี้
    checkFavorite();
    super.initState();
    documentStream = widget.dog.snapshots();
    FirebaseFirestore.instance.collection('dog').get().then((snapshot) {
      setState(() {
        allDogsSnapshot = snapshot;
      });
    });
  }

  Future<void> checkFavorite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference favoriteCollection =
        FirebaseFirestore.instance.collection('customer');

    DocumentSnapshot snapshot = await widget.dog.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    // Check if the dog is already in the favorite list
    QuerySnapshot querySnapshot = await favoriteCollection
        .doc(currentUser!.email)
        .collection('favorite dog')
        .where('id_dog', isEqualTo: data?['id_dog'])
        .limit(1)
        .get();
    setState(() {
      isFavorite = querySnapshot.docs.isEmpty ? false : true;
      //เช็คข้อมูลในisFavorite
    });

    // ignore: avoid_print
    print('isfav$isFavorite');
  }

  Future<void> addToFavorite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    CollectionReference favoriteCollection =
        FirebaseFirestore.instance.collection('customer');

    DocumentSnapshot snapshot = await widget.dog.get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    // Check if the dog is already in the favorite list
    QuerySnapshot querySnapshot = await favoriteCollection
        .doc(currentUser!.email)
        .collection('favorite dog')
        .where('id_dog', isEqualTo: data?['id_dog'])
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // Add the dog to the favorite list
      return favoriteCollection
          .doc(currentUser.email)
          .collection('favorite dog')
          .doc(data?['id_dog']) // กำหนด Document ID เป็นรหัสสุนัข
          .set(
              data!) // ใช้ .set(data) เพื่อเพิ่มเอกสารในคอลเลกชัน 'favorite dog' ด้วย Document ID ที่กำหนด
          .then((value) {
        setState(() {
          isFavorite = true;
        });
        // ignore: avoid_print
        print('Added to favorite');
      });
    } else {
      // Remove the dog from the favorite list
      String docId = querySnapshot.docs.first.id;
      return favoriteCollection
          .doc(currentUser.email)
          .collection('favorite dog')
          .doc(docId)
          .delete()
          .then((value) {
        setState(() {
          isFavorite = false;
        });
        // ignore: avoid_print
        print('Removed from favorite');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: documentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }

          final document = snapshot.data!;
          currentDocument = document;

          final idDog = document['id_dog'] ?? '';
          final name = document['sex'] ?? '';
          final price = document['price'] ?? '';
          final status = document['Status_sell'] ?? '';
          bool isSoldOut = status == 'มีบ้านแล้ว';
          final imageprofile = document['profileImage'] ?? '';
          final List<DocumentSnapshot> similarDogs = [];

          final String speciesToMatch = currentDocument!['species'];
          final String colorToMatch = currentDocument!['color'];

          for (var dog in allDogsSnapshot?.docs ?? []) {
            final species = dog['species'];
            final color = dog['color'];

            if (species == speciesToMatch && color == colorToMatch) {
              similarDogs.add(dog);
            }
          }
          return DefaultTabController(
            length: 4,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: Colors.black),
                  title: Text(
                    'ID : $idDog',
                    style:
                        const TextStyle(color: Color.fromRGBO(57, 57, 57, 1)),
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyNavigator()));
                        },
                        child: const Icon(
                          Icons.home,
                          size: 35,
                        ),
                      ),
                    )
                  ],
                ),
                body: Stack(
                  children: [
                    Positioned(
                      top: 36,
                      right: 30,
                      child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            //true  => false
                            size: 35,
                          ),
                          onPressed: () {
                            addToFavorite();
                          }),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundColor:
                                        const Color.fromRGBO(159, 203, 114, 1),
                                    child: CircleAvatar(
                                      radius: 41,
                                      backgroundImage:
                                          NetworkImage(imageprofile),
                                    ),
                                  ),
                                  if (isSoldOut)
                                    Positioned(
                                        top: 57,
                                        right: 0,
                                        child: Image.asset(
                                          'images/sold.png',
                                          height: 40,
                                        ))
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(57, 57, 57, 1)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        price,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Color.fromRGBO(57, 57, 57, 1)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        status,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Color.fromRGBO(57, 57, 57, 1)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'แนะนำสำหรับคุณ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [Text('กดเพื่อดู')],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: similarDogs.map((dog) {
                                    final imageUrl = dog['profileImage'];
                                    if (dog.id == currentDocument!.id) {
                                      return const SizedBox(); // Skip rendering this dog
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProfileDog(
                                                          dog: dog.reference)));
                                        },
                                        child: CircleAvatar(
                                          radius: 27,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: imageUrl.isNotEmpty
                                                ? Image.network(imageUrl).image
                                                : const AssetImage(
                                                    "images/logo.png"),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        const TabBar(
                          indicatorColor: Color.fromRGBO(159, 203, 114, 1),
                          tabs: [
                            Tab(
                              child: Text(
                                'ข้อมูลสุนัข',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.7,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Tab(
                                child: Text(
                              'รูปภาพ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            Tab(
                                child: Text(
                              'วัคซีน',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            Tab(
                              child: Text(
                                'Pedigree',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: TabBarView(
                          children: [
                            DataOfDog(documentReference: document.reference),
                            PhotoOfDog(
                              dog: document.reference,
                            ),
                            VacCine(
                              documentReference: document.reference,
                            ),
                            PediGree(documentReference: document.reference)
                          ],
                        ))
                      ],
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
