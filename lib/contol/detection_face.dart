import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petkub2/All%20data%20dog/dog_first.dart';
import 'package:tflite/tflite.dart';

class DetectionFace extends StatefulWidget {
  const DetectionFace({super.key});

  @override
  State<DetectionFace> createState() => _DetectionFaceState();
}

class _DetectionFaceState extends State<DetectionFace> {
  bool _loading = true;
  File? _image;
  List _output = [];
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_face.tflite',
      labels: 'assets/faces.txt',
    );
  }

  Future<void> pickImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  Future pickcamaraImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image!);
  }

  Future<void> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.25,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _output =
          output ?? []; // ใช้ "?? []" เพื่อให้ไม่เกิด null pointer exception
    });

    if (_output.isEmpty) {
      // หากไม่พบผลลัพธ์จากโมเดล
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ค้นหาไม่เจอ'),
            content: const Text('ไม่พบผลลัพธ์จากการค้นหาสุนัข'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('ตกลง'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'สแกนใบหน้า',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(57, 57, 57, 1)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                'images/nose.jpg',
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _image == null
                          ? Container()
                          : SizedBox(
                              height: 300,
                              width: 300,
                              //  MediaQuery.of(context).size.width - 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      _output.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                String idDog =
                                    _output[0]['label'].split(' ')[1];
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
                                            dog: documentReference),
                                      ),
                                    );
                                  } else {
                                    dialogBuilder(context);
                                  }
                                }).catchError((error) {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 85, right: 50, top: 10, bottom: 20),
                                child: ListTile(
                                  leading: Image.asset(
                                    'images/detect.png',
                                    height: 50,
                                  ),
                                  title: Text(
                                    'ID : ${_output[0]['label'].split(' ')[1]}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'กดเพื่อดู',
                                    style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/detect.png',
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'ค้นหาสุนัข',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(83, 129, 36, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () => pickImage(),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'รูปภาพ',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              const SizedBox(
                width: 20,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(83, 129, 36, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () => pickcamaraImage(),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'กล้อง',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยังไม่มีข้อมูล'),
          content: const Text(
            'รอทางฟาร์มทำการลงทะเบียนสุนัข',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
