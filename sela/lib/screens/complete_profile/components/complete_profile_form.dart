import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/components/default_button.dart';
import 'package:sela/screens/home/home_screen.dart';

import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/loading_screen.dart';
import '../../../utils/constants.dart';
import '../../../utils/env.dart';

class CompleteProfileForm extends StatefulWidget {
  final String email;
  final String password;

  const CompleteProfileForm(
      {required this.email, required this.password, super.key});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String? fullName;
  String? username;
  int? phoneNumber;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  void addError({String? error}) {
    if (error != null && !errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (error != null && errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> completeProfile(
      String username, String fullName, int phoneNumber) async {
    var url = Uri.parse('$DOTNET_URL_API_BACKEND/User/signup');
    var body = json.encode({
      'username': username,
      'name': fullName,
      'email': widget.email,
      'phoneNumber': phoneNumber,
      'password': widget.password,
    });

    try {
      http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Navigate to OTP screen on successful profile completion
        print(response.body);
        Navigator.pushNamed(context, HomeScreen.routeName);
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SignUp Successful'),
          ),
        );
        print(body);
      } else if (response.statusCode == 400) {
        // Show error dialog on failure
        print(response.body);
        Navigator.pop(context);
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User username already exists, please try again.'),
          ),
        );
      } else {
        // Show error dialog on failure
        print(response.body);
        Navigator.pop(context);
        _showErrorDialog('Profile Completion Failed');
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Completion Failed'),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog('Profile Completion Failed');
      // show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile Completion Failed'),
        ),
      );
      print(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Profile Completion Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: fullNameController,
            onSaved: (newValue) => fullName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Full Name",
              hintText: "Enter your full name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: usernameController,
            onSaved: (newValue) => username = newValue,
            decoration: const InputDecoration(
              labelText: "User Name",
              hintText: "Enter your user name",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = int.tryParse(newValue ?? ''),
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPhoneNumberNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Phone Number",
              hintText: "Enter your phone number",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          DefaultButton(
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingScreen()),
                );
                completeProfile(
                  usernameController.text,
                  fullNameController.text,
                  phoneNumber ?? 0,
                );
              }
            },
            text: "Sign Up",
          ),
        ],
      ),
    );
  }
}
