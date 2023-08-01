import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../All data dog/dog_first.dart';

class MyFavorite extends StatefulWidget {
  const MyFavorite({super.key});

  @override
  State<MyFavorite> createState() => _MyFavoriteState();
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

class _MyFavoriteState extends State<MyFavorite> {
  final currrenUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      body: StreamBuilder<QuerySnapshot>(
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

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('ไม่มีข้อมูลสุนัข'),
              );
            }
            final dogs = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                reverse: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 5),
                itemCount: dogs.length,
                itemBuilder: (context, index) {
                  final document = dogs[index];
                  final idDog = document['id_dog'] ?? '';
                  final species = document['species'] ?? '';
                  final sex = document['sex'] ?? '';
                  final date = document['date_of_birth'] ?? '';
                  final color = document['color'] ?? '';
                  final status = document['Status_sell'] ?? '';
                  bool isSoldOut = status == 'มีบ้านแล้ว';
                  final imageprofile = document['profileImage'] ?? '';
                  final age = calculateAge(date);
                  final ageString = '${age.years} ปี ${age.months} เดือน';

                  return GestureDetector(
                    onTap: () {
                      // Handle dog item click event
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('dog')
                                  .doc(idDog);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyProfileDog(dog: documentReference)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(
                              //     color:
                              //         const Color.fromRGBO(182, 182, 182, 1)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              if (isSoldOut)
                                Positioned(
                                    left: 3,
                                    child: Image.asset(
                                      'images/sold.png',
                                      height: 35,
                                    )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: const Color.fromRGBO(
                                          159, 203, 114, 1),
                                      child: CircleAvatar(
                                        radius: 46,
                                        backgroundImage:
                                            NetworkImage(imageprofile),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        children: [
                                          Text(ageString),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(sex),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(species),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('สี : $color'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
