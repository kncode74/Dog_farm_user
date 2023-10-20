import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class VacCine extends StatefulWidget {
  final DocumentReference documentReference;

  const VacCine({Key? key, required this.documentReference}) : super(key: key);

  @override
  State<VacCine> createState() => _VacCineState();
}

class _VacCineState extends State<VacCine> {
  late Stream<QuerySnapshot> documentStream;
  List<DocumentSnapshot> vaccineDocuments = [];

  @override
  void initState() {
    super.initState();
    documentStream = widget.documentReference.collection('vaccine').snapshots();
  }

  void showImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        // Clear the previous list of vaccineDocuments
        vaccineDocuments.clear();

        // Add the documents from the "vaccine" subcollection to vaccineDocuments
        vaccineDocuments.addAll(snapshot.data!.docs);

        return Scaffold(
          backgroundColor: const Color.fromRGBO(248, 247, 247, 1),
          body: ListView.builder(
            itemCount: vaccineDocuments.length,
            itemBuilder: (context, index) {
              final vaccineNumber = index + 1;
              final vaccineData =
                  vaccineDocuments[index].data() as Map<String, dynamic>;
              // Display the data from the vaccine document
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'ครั้งที่  $vaccineNumber',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          vaccineData['vaccinedate'].isEmpty
                                              ? 'ยังไม่มีข้อมูล'
                                              : vaccineData['vaccinedate'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: vaccineData['vaccinedate']
                                                    .isEmpty
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 6),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          vaccineData['vaccinetype'].isEmpty
                                              ? 'ยังไม่มีข้อมูล'
                                              : vaccineData['vaccinetype'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: vaccineData['vaccinetype']
                                                    .isEmpty
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  if (vaccineData['image_vaccine'] != null &&
                                      vaccineData['image_vaccine'].isNotEmpty) {
                                    showImage(
                                        context, vaccineData['image_vaccine']);
                                  }
                                },
                                child: SizedBox(
                                  height: 110,
                                  child: vaccineData['image_vaccine'] != null &&
                                          vaccineData['image_vaccine']
                                              .isNotEmpty
                                      ? Image.network(
                                          vaccineData['image_vaccine'],
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
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 50,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
