import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/components/new_custom_bottom_navbar.dart';
import 'package:sela/models/post_model.dart';
import 'package:sela/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../utils/colors.dart';
import '../../utils/env.dart';
import 'components/post_details_form.dart';
import 'components/post_images_form.dart';

class PostStepper extends StatefulWidget {
  @override
  _PostStepperState createState() => _PostStepperState();
}

class _PostStepperState extends State<PostStepper> {
  int _currentStep = 0;
  List<String> _imageUrls = [];
  final GlobalKey<PostDetailsFormState> _detailsFormKey =
      GlobalKey<PostDetailsFormState>();

  void _onNext(List<String> imageUrls) {
    setState(() {
      _imageUrls = imageUrls;
      _currentStep++;
    });
  }

  Future<void> _onSubmit(Map<String, dynamic> postDetails) async {
    // Ensure the `type` field is properly converted to an integer
    int type = postDetails['type'] == 'Organization' ? 0 : 1;

    // Ensure tags and providers are lists of strings
    List<String> tags = List<String>.from(postDetails['tags'] as List);
    List<String> providers =
        List<String>.from(postDetails['providers'] as List);

    // Combine _imageUrls and postDetails into a single Post object
    final newPost = Post(
      imageUrls: _imageUrls,
      name: postDetails['name'],
      type: type, // type is now an integer
      tags: tags,
      title: postDetails['title'],
      description: postDetails['description'],
      providers: providers,
      about: postDetails['about'],
      socialLinks: postDetails['socialLinks'],
    );

    // Handle the new create_post (e.g., send to API or add to local state)
    print('New Post: $newPost');
    // Convert the Post object to JSON string
    final jsonPost = jsonEncode(newPost.toJson());

    // Print JSON data before sending
    print('JSON to be sent: $jsonPost');

    // Retrieve the cookie from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    // Send the data to the endpoint
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/user');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
      body: jsonPost,
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Post submitted successfully!');
      // Navigate to the home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
      // Show a toast for the success
      toastification.show(
        context: context,
        title: const Text(
          'Post submitted successfully',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          'Thank you for submitting your post!',
          style: TextStyle(color: Colors.white),
        ),
        primaryColor: Colors.green,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        style: ToastificationStyle.flat,
        showProgressBar: true,
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.success,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: false,
        pauseOnHover: true,
        dragToClose: true,
        applyBlurEffect: true,
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) =>
              print('Toast ${toastItem.id} close button tapped'),
          onAutoCompleteCompleted: (toastItem) =>
              print('Toast ${toastItem.id} auto complete completed'),
          onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
        ),
      );
    } else {
      // Handle error response
      print('Failed to submit create_post: ${response.body}');
      // Show a toast for the error
      toastification.show(
        context: context,
        title: const Text(
          'Error submitting create post',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          'Failed to submit create post',
          style: TextStyle(color: Colors.white),
        ),
        primaryColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        style: ToastificationStyle.flat,
        showProgressBar: true,
        autoCloseDuration: const Duration(seconds: 5),
        type: ToastificationType.error,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: false,
        pauseOnHover: true,
        dragToClose: true,
        applyBlurEffect: true,
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) =>
              print('Toast ${toastItem.id} close button tapped'),
          onAutoCompleteCompleted: (toastItem) =>
              print('Toast ${toastItem.id} auto complete completed'),
          onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stepper(
        connectorThickness: 2.0,
        connectorColor: WidgetStateColor.resolveWith((states) => kPrimaryColor),
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            // Move to the next step
            setState(() {
              _currentStep++;
            });
          } else if (_currentStep == 1) {
            // Submit the form
            if (_detailsFormKey.currentState != null) {
              _onSubmit(_detailsFormKey.currentState!.collectFormData());
            } else {
              print('Form key current state is null');
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else if (_currentStep == 0) {
            Navigator.pop(context);
          }
        },
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        steps: [
          Step(
            title: const Text('Select Images'),
            subtitle: const Text('Upload images for your post'),
            content: PostImagesForm(onNext: _onNext),
            isActive: _currentStep == 0,
            state: _currentStep == 0 ? StepState.editing : StepState.complete,
          ),
          Step(
            title: const Text('Details'),
            subtitle: const Text('Provide details for your post'),
            content: PostDetailsForm(key: _detailsFormKey, onSubmit: _onSubmit),
            isActive: _currentStep == 1,
            state: _currentStep == 1 ? StepState.editing : StepState.indexed,
          ),
        ],
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _currentStep == 1;

          return Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isLastStep ? 'Submit' : 'Continue'),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: details.onStepCancel,
                style: TextButton.styleFrom(
                  // backgroundColor: buttonColor,
                  foregroundColor: textColor2,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isLastStep ? 'Back' : 'Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }
}
