import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostImagesForm extends StatefulWidget {
  final Function(List<String>) onNext;

  const PostImagesForm({Key? key, required this.onNext}) : super(key: key);

  @override
  _PostImagesFormState createState() => _PostImagesFormState();
}

class _PostImagesFormState extends State<PostImagesForm> {
  final List<String> _imageUrls = [];
  final List<File> _images = [];
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _images.clear(); // Clear the previous images
        _images.addAll(images.map((e) => File(e.path)));
      });
      await _uploadImages();
      widget.onNext(
          _imageUrls); // Ensure the onNext function is called with the image URLs
    }
  }

  Future<void> _uploadImages() async {
    final List<String> imageUrls = [];
    for (var image in _images) {
      final String imageName = image.path.split('/').last;
      final String fullPath = 'public/$imageName';

      try {
        final String uploadedPath = await _supabaseClient.storage
            .from('postimages')
            .upload(fullPath, image,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false));

        // // Manually generate the public URL
        // final String publicUrl =
        //     'https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/$fullPath';

        // Verify if the image is uploaded successfully
        print('Image uploaded: $uploadedPath');

        final String publicUrl =
            _supabaseClient.storage.from('postimages').getPublicUrl(fullPath);

        // Verify if the public URL is generated successfully
        print('Public URL: $publicUrl');

        imageUrls.add(publicUrl);
      } catch (e) {
        // Handle error if needed
        print('Error uploading image: $e');

        // snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error uploading image, try to upload smaller image'),
          ),
        );
      }
    }
    setState(() {
      _imageUrls.clear();
      _imageUrls.addAll(imageUrls);
    });
    // widget.onNext(_imageUrls);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        ElevatedButton(
          onPressed: _pickImages,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            backgroundColor: kPrimaryColor,
          ),
          child: const Text(
            'Select Images',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Wrap(
          children: _imageUrls
              .map(
                (imageUrl) => Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.error,
                    color: Colors.deepPurple,
                    size: 50,
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
      ],
    );
  }
}
