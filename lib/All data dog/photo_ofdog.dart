import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoOfDog extends StatefulWidget {
  final DocumentReference dog;

  const PhotoOfDog({Key? key, required this.dog}) : super(key: key);

  @override
  State<PhotoOfDog> createState() => _PhotoOfDogState();
}

class _PhotoOfDogState extends State<PhotoOfDog> {
  late Stream<QuerySnapshot> imageStream;

  @override
  void initState() {
    super.initState();
    imageStream = widget.dog.collection('image').snapshots();
  }

  void _showImageDialog(BuildContext context, List<String> images) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: PhotoViewGallery.builder(
                    itemCount: images.length,
                    builder: (context, index) {
                      String url = images[index];
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(url),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      );
                    },
                    scrollPhysics: const BouncingScrollPhysics(),
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: imageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {}

        final documents = snapshot.data!.docs;

        return Scaffold(
          backgroundColor: Colors.white,
          body: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data() as Map<String, dynamic>;
              final description = data['description'] as String;

              //final images = data['images'] as List<String>;
              final images = data['images'];
              return Card(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, gridIndex) {
                        String url = images[gridIndex];
                        List<String> castedImages = images.cast<String>();

                        return InkWell(
                          onTap: () {
                            _showImageDialog(context, castedImages);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
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
