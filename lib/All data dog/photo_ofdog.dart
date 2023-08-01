import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoOfDog extends StatefulWidget {
  final DocumentReference dog;

  const PhotoOfDog({Key? key, required this.dog}) : super(key: key);

  @override
  State<PhotoOfDog> createState() => _PhotoOfDogState();
}

class _PhotoOfDogState extends State<PhotoOfDog> {
  late Stream<QuerySnapshot> imageStream;
  void showImage(BuildContext context, String imageUrl, String imageId) {
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
  void initState() {
    super.initState();
    // Get the image collection stream under the specified dog document reference
    imageStream = widget.dog.collection('image').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: imageStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              String url = snapshot.data!.docs[index].get('url');
              String imageId = snapshot.data!.docs[index].id;
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: () => showImage(context, url, imageId),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: url,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
