import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataOfDog extends StatefulWidget {
  final DocumentReference documentReference;

  const DataOfDog({Key? key, required this.documentReference})
      : super(key: key);

  @override
  State<DataOfDog> createState() => _DataOfDogState();
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

class _DataOfDogState extends State<DataOfDog> {
  late Stream<DocumentSnapshot> documentStream;
  DocumentSnapshot? currentDocument;

  @override
  void initState() {
    super.initState();
    documentStream = widget.documentReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
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
        final status = document['status'] ?? '';
        final idDog = document['id_dog'] ?? '';
        final species = document['species'] ?? '';
        final sex = document['sex'] ?? '';
        final price = document['price'] ?? '';
        final statussell = document['Status_sell'] ?? '';
        //final imageprofile = document['profileImage'] ?? '';
        final date = document['date_of_birth'] ?? '';
        final weight = document['weight'] ?? '';
        final height = document['height'] ?? '';

        final color = document['color'] ?? '';

        final age = calculateAge(date);
        final ageString = '${age.years} ปี ${age.months} เดือน';
        // Rest of your code...
        return Scaffold(
            backgroundColor: const Color.fromRGBO(248, 247, 247, 1),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //PROFILE NAME
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'ข้อมูลการขาย',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Column(
                                          children: [
                                            dataprivate('สถานะ', status),
                                            dataprivate('รหัสประจำตัว', idDog),
                                            dataprivate('พันธุ์', species),
                                            dataprivate('เพศ', sex),
                                            dataprivate('ราคา', price),
                                            dataprivate('การขาย', statussell)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'ข้อมูลส่วนตัว',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15, top: 5),
                                        child: Column(
                                          children: [
                                            dataprivate('วันเกิด', date),
                                            dataprivate(
                                                'ปัจจุบันอายุ', ageString),
                                            dataprivate('น้ำหนัก', weight),
                                            dataprivate('ส่วนสูง', height),
                                            dataprivate('สี', color)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}

Widget dataprivate(String title, String inputtitle) => Container(
    height: 45,
    decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color.fromRGBO(159, 203, 114, 1)))),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('$title  :   ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(
            inputtitle,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    ));
