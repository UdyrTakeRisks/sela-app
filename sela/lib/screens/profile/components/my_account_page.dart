import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sela/components/default_button.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';
import 'package:sela/utils/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../models/user_model.dart';
import '../../../utils/constants.dart';
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
          const SnackBar(content: Text('Image updated successfully')),
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error uploading image, try again')),
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit $fieldLabel',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              fieldLabel != 'Images'
                  ? fieldLabel == 'Password'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: oldPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter your current password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: getProportionateScreenHeight(10)),
                            TextField(
                              controller: controller,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter your new password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        )
                      : TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Enter your new $fieldLabel',
                            border: const OutlineInputBorder(),
                          ),
                        )
                  : SizedBox(
                      height: 100,
                      child: DefaultButton(
                        text: 'Select Image',
                        press: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _pickImage();
                        },
                      ),
                    ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (fieldLabel == 'Password' &&
                          controller.text.length < 8) {
                        // Check password length
                        toastification.show(
                          context: context,
                          title: const Text(
                            'Password too short',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: Text(
                            'Password must be at least 8 characters long',
                            style: TextStyle(color: Colors.white),
                          ),
                          primaryColor: Colors.redAccent,
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          style: ToastificationStyle.flat,
                          showProgressBar: false,
                          autoCloseDuration: const Duration(seconds: 5),
                          type: ToastificationType.error,
                          closeButtonShowType: CloseButtonShowType.onHover,
                          closeOnClick: false,
                          pauseOnHover: true,
                          dragToClose: true,
                          applyBlurEffect: true,
                          callbacks: ToastificationCallbacks(
                            onTap: (toastItem) =>
                                print('Toast ${toastItem.id} tapped'),
                            onCloseButtonTap: (toastItem) => print(
                                'Toast ${toastItem.id} close button tapped'),
                            onAutoCompleteCompleted: (toastItem) => print(
                                'Toast ${toastItem.id} auto complete completed'),
                            onDismissed: (toastItem) =>
                                print('Toast ${toastItem.id} dismissed'),
                          ),
                        );
                      } else if (fieldLabel == 'Email' &&
                          !emailValidatorRegExp.hasMatch(controller.text)) {
                        // Show error if email is invalid or doesn't contain '@' symbol in toastification
                        toastification.show(
                          context: context,
                          title: const Text(
                            'Invalid Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: const Text(
                            'Please enter a valid email address',
                            style: TextStyle(color: Colors.white),
                          ),
                          primaryColor: Colors.redAccent,
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          style: ToastificationStyle.flat,
                          showProgressBar: false,
                          autoCloseDuration: const Duration(seconds: 5),
                          type: ToastificationType.error,
                          closeButtonShowType: CloseButtonShowType.onHover,
                          closeOnClick: false,
                          pauseOnHover: true,
                          dragToClose: true,
                          applyBlurEffect: true,
                          callbacks: ToastificationCallbacks(
                            onTap: (toastItem) =>
                                print('Toast ${toastItem.id} tapped'),
                            onCloseButtonTap: (toastItem) => print(
                                'Toast ${toastItem.id} close button tapped'),
                            onAutoCompleteCompleted: (toastItem) => print(
                                'Toast ${toastItem.id} auto complete completed'),
                            onDismissed: (toastItem) =>
                                print('Toast ${toastItem.id} dismissed'),
                          ),
                        );
                      } else if (fieldLabel == 'Phone Number' &&
                          controller.text.length <= 10) {
                        print('Phone number too short');
                        // Show error if phone number is too short in toastification
                        toastification.show(
                          context: context,
                          title: const Text(
                            'Phone number too short',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: const Text(
                            'Phone number must be at least 8 characters long',
                            style: TextStyle(color: Colors.white),
                          ),
                          primaryColor: Colors.redAccent,
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          style: ToastificationStyle.flat,
                          showProgressBar: false,
                          autoCloseDuration: const Duration(seconds: 5),
                          type: ToastificationType.error,
                          closeButtonShowType: CloseButtonShowType.onHover,
                          closeOnClick: false,
                          pauseOnHover: true,
                          dragToClose: true,
                          applyBlurEffect: true,
                          callbacks: ToastificationCallbacks(
                            onTap: (toastItem) =>
                                print('Toast ${toastItem.id} tapped'),
                            onCloseButtonTap: (toastItem) => print(
                                'Toast ${toastItem.id} close button tapped'),
                            onAutoCompleteCompleted: (toastItem) => print(
                                'Toast ${toastItem.id} auto complete completed'),
                            onDismissed: (toastItem) =>
                                print('Toast ${toastItem.id} dismissed'),
                          ),
                        );
                      } else {
                        try {
                          await ProfileServices.updateProfileField(fieldLabel,
                              oldPasswordController.text, controller.text);

                          Navigator.of(context).pop(); // Close the dialog
                          setState(() {
                            futureUserDetails =
                                ProfileServices.fetchUserDetails(context);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$fieldLabel updated successfully'),
                            ),
                          );
                        } catch (e) {
                          print('Error updating $fieldLabel: $e');
                          Navigator.of(context).pop(); // Close the dialog
                          toastification.show(
                            context: context,
                            title: Text(
                              'Error updating $fieldLabel',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: Text(
                              ' Check your password\nAn error occurred while updating $fieldLabel. Please try again.',
                              style: const TextStyle(color: Colors.white),
                            ),
                            primaryColor: Colors.redAccent,
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            style: ToastificationStyle.flat,
                            showProgressBar: false,
                            autoCloseDuration: const Duration(seconds: 5),
                            type: ToastificationType.error,
                            closeButtonShowType: CloseButtonShowType.onHover,
                            closeOnClick: false,
                            pauseOnHover: true,
                            dragToClose: true,
                            applyBlurEffect: true,
                            callbacks: ToastificationCallbacks(
                              onTap: (toastItem) =>
                                  print('Toast ${toastItem.id} tapped'),
                              onCloseButtonTap: (toastItem) => print(
                                  'Toast ${toastItem.id} close button tapped'),
                              onAutoCompleteCompleted: (toastItem) => print(
                                  'Toast ${toastItem.id} auto complete completed'),
                              onDismissed: (toastItem) =>
                                  print('Toast ${toastItem.id} dismissed'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureUserDetails = ProfileServices.fetchUserDetails(context);
            futureProfilePhotoUrl = ProfileServices.fetchPhoto(context);
          });
        },
        color: primaryColor,
        backgroundColor: backgroundColor4,
        child: FutureBuilder<Users>(
          future: futureUserDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
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
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 5,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 5,
                                      ),
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
                                  bottom: 0,
                                  right: 0,
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
                          SizedBox(height: getProportionateScreenHeight(20)),
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
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 30),
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
                            value: user
                                .phone, // Replace with actual phone number field
                            onPressed: () {
                              _editField('Phone Number', user.phone);
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
      ),
    );
  }
}
