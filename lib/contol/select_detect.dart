import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/farm.dart';

import 'detection_face.dart';
import 'detection_nose.dart';

class SelectDetection extends StatefulWidget {
  const SelectDetection({super.key});

  @override
  State<SelectDetection> createState() => _SelectDetectionState();
}

class _SelectDetectionState extends State<SelectDetection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        centerTitle: true,
        title: const Text('ค้นหาสุนัข'),
        backgroundColor: const Color.fromRGBO(83, 129, 36, 1),
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('farm')
                .limit(1) //กำหนดดึงข้อมูลจากเอกสารที่ 1
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final doc = snapshot.data!.docs.first; //เอกสารลำดับที่1
                final userData = doc.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, right: 15),
                      child: ListTile(
                          leading: Image.asset('images/soonak Logo.png'),
                          title: Text(
                            userData['farm_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(userData['telephone']),
                          trailing: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromRGBO(240, 239, 239, 1)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Farm()));
                            },
                            child: const Text(' ดูข้อมูลเพิ่มเติม '),
                          )),
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
          Center(
            child: Column(children: [
              const SizedBox(height: 170),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 215, 215, 215), // สีของเงา
                            offset: Offset(0, 2), // ตำแหน่งเงาแนวแกน X และ Y
                            blurRadius: 5.0, // รัศมีของเงา
                            spreadRadius: 2.0, // การกระจายของเงา
                          )
                        ]),
                    child: Stack(
                      children: [
                        const Positioned(
                            top: 20,
                            left: 110,
                            child: Text(
                              'Dog Face',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        const Positioned(
                            top: 47,
                            left: 110,
                            child: Text(
                              'ภาพใบหน้าของสุนัข',
                              style: TextStyle(fontSize: 16),
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const CircleAvatar(
                                  radius: 37,
                                  backgroundImage:
                                      AssetImage('images/nose.jpg'),
                                ),
                                const SizedBox(
                                  width: 185,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DetectionFace()));
                                  },
                                  child: const Icon(
                                    Icons.arrow_circle_right,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 215, 215, 215), // สีของเงา
                            offset: Offset(0, 2), // ตำแหน่งเงาแนวแกน X และ Y
                            blurRadius: 5.0, // รัศมีของเงา
                            spreadRadius: 2.0, // การกระจายของเงา
                          )
                        ]),
                    child: Stack(
                      children: [
                        const Positioned(
                            top: 20,
                            left: 110,
                            child: Text(
                              'Dog Nose',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        const Positioned(
                            top: 47,
                            left: 110,
                            child: Text(
                              'ภาพจมูกของสุนัข',
                              style: TextStyle(fontSize: 16),
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const CircleAvatar(
                                  radius: 37,
                                  backgroundImage:
                                      AssetImage('images/face.jpg'),
                                ),
                                const SizedBox(
                                  width: 185,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DetectionNose()));
                                  },
                                  child: const Icon(
                                    Icons.arrow_circle_right,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
