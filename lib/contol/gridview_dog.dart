import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/All%20data%20dog/dog_first.dart';

class MyDataOdDog extends StatefulWidget {
  const MyDataOdDog({Key? key}) : super(key: key);

  @override
  State<MyDataOdDog> createState() => _MyDataOdDogState();
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

class _MyDataOdDogState extends State<MyDataOdDog> {
  CollectionReference dogCollection =
      FirebaseFirestore.instance.collection("dog");

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    dogCollection = FirebaseFirestore.instance.collection("dog");
  }

  final firstMatchIndex = 0;

  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  void debouncedSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(159, 203, 114, 1),
        title: const Center(child: Text('ข้อมูลสุนัข')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dogCollection.snapshots(),
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

          final filteredDogs = dogs.where((dog) {
            final dogData = dog.data() as Map<String, dynamic>;
            final date = dogData['date_of_birth'] ?? '';
            final color = dogData['color'] ?? '';
            final age = calculateAge(date);
            final ageString = '${age.years} ปี ${age.months} เดือน';

            return color.contains(searchQuery) ||
                ageString.contains(searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(229, 227, 227, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search)),
                    onChanged: (val) {
                      EasyDebounce.debounce(
                        'searchDebounce', // debounce identifier
                        const Duration(milliseconds: 500), // debounce duration
                        () => debouncedSearch(val), // function to be executed
                      );
                    },
                  ),
                ),
              ),
              //
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    reverse: false,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: filteredDogs.length,
                    itemBuilder: (context, index) {
                      final dogData =
                          filteredDogs[index].data() as Map<String, dynamic>;

                      final species = dogData['species'] ?? '';
                      final sex = dogData['sex'] ?? '';
                      final date = dogData['date_of_birth'] ?? '';
                      final color = dogData['color'] ?? '';
                      final imageprofile = dogData['profileImage'] ?? '';
                      final status = dogData['Status_sell'] ?? '';
                      bool isSoldOut = status == 'มีบ้านแล้ว';
                      final age = calculateAge(date);
                      final ageString = '${age.years} ปี ${age.months} เดือน';
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfileDog(
                                      dog: filteredDogs[index].reference)));
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
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
