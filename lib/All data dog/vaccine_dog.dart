import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VacCine extends StatefulWidget {
  final DocumentReference documentReference;

  const VacCine({Key? key, required this.documentReference}) : super(key: key);

  @override
  State<VacCine> createState() => _VacCineState();
}

class _VacCineState extends State<VacCine> {
  late Stream<DocumentSnapshot> documentStream;
  DocumentSnapshot? currentDocument;
  @override
  void initState() {
    super.initState();
    documentStream = widget.documentReference.snapshots();
  }

  void showImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(imageUrl),
          ],
        ),
      ),
    );
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

        final vaccinetype1 = document['vaccinetype1'] ?? '';
        final vaccinetype2 = document['vaccinetype2'] ?? '';
        final vaccinedate1 = document['vaccinedate1'] ?? '';
        final vaccinedate2 = document['vaccinedate1'] ?? '';
        final imageVac = document['vaccineImage'] ?? '';
        //หากยังไม่มีข้อมูลส่วนนี้จะแสดง
        if (vaccinetype1.isEmpty &&
            vaccinedate2.isEmpty &&
            vaccinedate1.isEmpty &&
            vaccinetype2.isEmpty) {
          return const Text(
            'ยังไม่มีข้อมูล',
          );
        }

        return Scaffold(
            backgroundColor: const Color.fromRGBO(248, 247, 247, 1),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => showImage(context, imageVac),
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
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                'สมุดฉีดวัคซีนน้องหมา',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 110,
                                              child: Image.network(
                                                imageVac.isNotEmpty
                                                    ? imageVac // This should be the image URL as a string
                                                    : '', // If imagePedigree is empty, provide an empty string for the URL
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons
                                                        .add_photo_alternate_outlined,
                                                    size: 50,
                                                  );
                                                },
                                                fit: BoxFit
                                                    .cover, // Adjust this based on how you want the image to be fitted
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
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
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'ครั้งที่ 1',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 6, bottom: 4),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'images/calendar.png',
                                                    height: 22,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    vaccinedate1,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 6),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'images/vaccine.png',
                                                    height: 22,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    vaccinetype1,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
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
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'ครั้งที่ 2',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 6, bottom: 4),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      'images/calendar.png',
                                                      height: 22,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 13,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      vaccinedate2.isEmpty
                                                          ? 'ยังไม่มีข้อมูล'
                                                          : vaccinedate2,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            vaccinedate2.isEmpty
                                                                ? Colors.red
                                                                : Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 6),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Image.asset(
                                                      'images/vaccine.png',
                                                      height: 22,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 13,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      vaccinetype2.isEmpty
                                                          ? 'ยังไม่มีข้อมูล'
                                                          : vaccinetype2,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            vaccinedate2.isEmpty
                                                                ? Colors.red
                                                                : Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ]));
      },
    );
  }
}
