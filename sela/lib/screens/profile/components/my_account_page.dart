import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sela/components/default_button.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';
import 'package:sela/utils/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user_model.dart';
import 'edit_profile_field.dart'; // Custom widget for editable fields
import 'profile_services.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  static String routeName = "/my_account";

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late Future<String?> futureProfilePhotoUrl;
  late Future<Users> futureUserDetails; // Declare without initialization

  final SupabaseClient _supabaseClient =
      SupabaseClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize futureUserDetails here, after context is fully initialized
    futureUserDetails = ProfileServices.fetchUserDetails(context);
    futureProfilePhotoUrl = ProfileServices.fetchPhoto(context);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      final String imageName = _selectedImage!.path.split('/').last;
      final String fullPath = 'public/$imageName';

      // final String? oldUrl = await ProfileServices.fetchPhoto(context);
      // final String? oldImageName = oldUrl?.split('/').last;

      try {
        // // remove the old image from the bucket
        // final List<FileObject> objects = await _supabaseClient.storage
        //     .from('userimage')
        //     .remove([oldImageName!]);

        final String uploadedPath = await _supabaseClient.storage
            .from('userimage')
            .upload(fullPath, _selectedImage!,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false));

        final String publicUrl =
            _supabaseClient.storage.from('userimage').getPublicUrl(fullPath);

        print('Image uploaded: $uploadedPath');
        print('Public URL: $publicUrl');

        await ProfileServices.updateProfileField('Images', '', publicUrl);

        setState(() {
          futureUserDetails = ProfileServices.fetchUserDetails(context);
          futureProfilePhotoUrl = Future.value(publicUrl);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image updated successfully')),
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image, try again')),
        );
      }
    }
  }

  void _editField(String fieldLabel, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    TextEditingController oldPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $fieldLabel'),
        content: fieldLabel != 'Images'
            ? fieldLabel == 'Password'
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: oldPasswordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your current password',
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter your new password',
                        ),
                      ),
                    ],
                  )
                : TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your new $fieldLabel',
                    ),
                  )
            : DefaultButton(
                text: 'Select Image',
                press: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImage();
                },
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ProfileServices.updateProfileField(
                    fieldLabel, oldPasswordController.text, controller.text);

                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  futureUserDetails = ProfileServices.fetchUserDetails(context);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$fieldLabel updated successfully'),
                  ),
                );
              } catch (e) {
                print('Error updating $fieldLabel: $e');
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update $fieldLabel'),
                  ),
                );
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<Users>(
        future: futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load user details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user details found'));
          } else {
            Users user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.elliptical(600, 300),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: FutureBuilder<String?>(
                                      future: futureProfilePhotoUrl,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(
                                            color: primaryColor,
                                          );
                                        } else if (snapshot.hasError ||
                                            snapshot.data == null ||
                                            snapshot.data!.isEmpty) {
                                          return Icon(
                                            Icons.person,
                                            size: 115,
                                            color: primaryColor,
                                          );
                                        } else {
                                          return Image.network(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: 115,
                                            height: 115,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.person,
                                                size: 115,
                                                color: Colors.grey,
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: buttonColor.withOpacity(0.8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _editField(
                                          'Images', user.userPhoto ?? '');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          user.name,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: backgroundColor4,
                                blurRadius: 10,
                              ),
                            ],
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontFeatures: const [
                              FontFeature.enable('smcp'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                    child: Column(
                      children: [
                        EditProfileField(
                          label: 'Username',
                          value: user.username,
                          onPressed: () {
                            _editField('Username', user.username);
                          },
                        ),
                        EditProfileField(
                          label: 'Name',
                          value: user.name,
                          onPressed: () {
                            _editField('Name', user.name);
                          },
                        ),
                        EditProfileField(
                          label: 'Email',
                          value: user.email,
                          onPressed: () {
                            _editField('Email', user.email);
                          },
                        ),
                        EditProfileField(
                          label: 'Phone Number',
                          value:
                              '${user.phone}', // Replace with actual phone number field
                          onPressed: () {
                            _editField('Phone Number', '${user.phone}');
                          },
                        ),
                        EditProfileField(
                          label: 'Password',
                          value:
                              '************', // Placeholder until implemented
                          onPressed: () {
                            _editField('Password', '');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
