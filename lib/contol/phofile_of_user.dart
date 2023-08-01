import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customer/favorite.dart';
import '../customer/user_data.dart';

class MyProfileUsers extends StatefulWidget {
  const MyProfileUsers({Key? key}) : super(key: key);

  @override
  State<MyProfileUsers> createState() => _MyProfileUsersState();
}

class Age {
  final int years;
  final int months;

  Age(this.years, this.months);
}

Age calculateAge(String dateOfBirth) {
  try {
    // Remove extra spaces and split the date components
    final components = dateOfBirth.trim().split('/');

    if (components.length == 3) {
      final int? day = int.tryParse(components[0]);
      final int? month = int.tryParse(components[1]);
      final int? year = int.tryParse(components[2]);

      if (day != null && month != null && year != null) {
        final DateTime today = DateTime.now();
        final DateTime dob = DateTime(year, month, day);

        int years = today.year - dob.year;
        int months = today.month - dob.month;

        if (months < 0) {
          years--;
          months += 12;
        }

        return Age(years, months);
      }
    }
  } catch (e) {
    // ignore: avoid_print
    print("Error calculating age: $e");
  }

  return Age(0, 0); // Return a default value in case of any errors
}

class _MyProfileUsersState extends State<MyProfileUsers> {
  final currrenUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('customer');
  //final favoriteCollection = FirebaseFirestore.instance.collection('customer');

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(159, 203, 114, 1),
          title: const Center(child: Text('ข้อมูลส่วนตัว')),
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
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              const Color.fromRGBO(159, 203, 114, 1),
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
                      children: [Text(currrenUser.displayName.toString())],
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
                      height: 20,
                    ),
                    TabBar(tabs: [
                      Tab(
                          child: Image.asset(
                        'images/heart.png',
                        height: 35,
                      )),
                      Tab(
                        child: Image.asset(
                          'images/user.png',
                          height: 35,
                        ),
                      )
                    ]),
                    const Expanded(
                        child: TabBarView(
                      children: [MyFavorite(), UserCollectionData()],
                    ))
                  ],
                ),
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
