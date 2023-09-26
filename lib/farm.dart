import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Farm extends StatelessWidget {
  const Farm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'ข้อมูลฟาร์มสุนัข',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('farm')
            .limit(1) //กำหนดดึงข้อมูลจากเอกสารที่ 1
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doc = snapshot.data!.docs.first; //เอกสารลำดับที่1
            final userData = doc.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/soonak Logo.png',
                              height: 100,
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'About me',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                userData['etc'],
                              ),
                            )
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'images/clock.png',
                              height: 35,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Row(
                              children: [
                                Text(userData['time_open']),
                                const Text(' - '),
                                Text(userData['time_close']),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset('images/location.png',
                                        height: 35),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(userData['adress']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(userData['tombon']),
                                    const Text(' , '),
                                    Text(userData['aomphue']),
                                  ],
                                ),
                                Row(
                                  children: [Text(userData['province'])],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset('images/phone-call.png', height: 35),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(userData['telephone'])
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset('images/meta.png', height: 35),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(userData['Facebook'])
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset('images/line.png', height: 35),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(userData['Line'])
                          ],
                        )
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
