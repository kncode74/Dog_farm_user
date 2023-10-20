import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petkub2/All%20data%20dog/dog_first.dart';
import 'package:photo_view/photo_view.dart';

class PediGree extends StatefulWidget {
  final DocumentReference documentReference;

  const PediGree({Key? key, required this.documentReference}) : super(key: key);

  @override
  State<PediGree> createState() => _PediGreeState();
}

class _PediGreeState extends State<PediGree> {
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

  Future<void> showNotFoundDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ไม่พบข้อมูล'),
          content: const Text('ขออภัย ไม่พบข้อมูลที่คุณต้องการค้นหา'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 247, 1),
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

          final dad = document['dad'] ?? '';
          final mom = document['mom'] ?? '';

          final imagePed = document['pedigreeImage'] ?? '';

          // if (dad.isEmpty && mom.isEmpty) {
          //   return const Text('ยังไม่มีข้อมูล');
          // }

          return Scaffold(
            backgroundColor: const Color.fromRGBO(248, 247, 247, 1),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => showImage(context, imagePed),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                                                  'ใบเพดดีกรีน้องหมา',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
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
                                                imagePed.isNotEmpty
                                                    ? imagePed // This should be the image URL as a string
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
                                                  return const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('ยังไม่มีข้อมูล'),
                                                    ],
                                                  );
                                                },
                                                fit: BoxFit
                                                    .cover, // Adjust this based on how you want the image to be fitted
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //เพิ่มพ่อแม่
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color.fromRGBO(213, 213, 213, 1),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    Color.fromRGBO(241, 241, 241, 1),
                                backgroundImage:
                                    AssetImage('images/golden-retriever.png'),
                              )),
                          title: const Text(
                            'พ่อพันธุ์',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            dad.isEmpty ? 'ยังไม่มีข้อมูล' : dad,
                            style: TextStyle(
                              fontSize: 16,
                              color: dad.isEmpty ? Colors.red : Colors.black,
                            ),
                          ),
                          onTap: () {
                            String idDog = dad;
                            if (dad.isNotEmpty) {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('dog')
                                      .doc(idDog);
                              documentReference
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyProfileDog(
                                        dog: documentReference,
                                      ),
                                    ),
                                  );
                                } else {
                                  showNotFoundDialog(context);
                                }
                              }).catchError((error) {
                                // Handle errors here
                                // ignore: avoid_print
                                print("Error getting document: $error");
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color.fromRGBO(83, 129, 36, 1),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    Color.fromRGBO(159, 203, 114, 1),
                                backgroundImage:
                                    AssetImage('images/samoyed.png'),
                              )),
                          title: const Text(
                            'แม่พันธุ์',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            mom.isEmpty ? 'ยังไม่มีข้อมูล' : mom,
                            style: TextStyle(
                              fontSize: 16,
                              color: mom.isEmpty ? Colors.red : Colors.black,
                            ),
                          ),
                          onTap: () {
                            String idDog = mom;
                            if (mom.isNotEmpty) {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('dog')
                                      .doc(idDog);
                              documentReference
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                if (documentSnapshot.exists) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyProfileDog(
                                        dog: documentReference,
                                      ),
                                    ),
                                  );
                                } else {
                                  showNotFoundDialog(context);
                                }
                              }).catchError((error) {
                                // Handle errors here
                                // ignore: avoid_print
                                print("Error getting document: $error");
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
