import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/utils/colors.dart';
import 'package:sela/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/custom_suffix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../components/loading_screen.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';
import '../../admin/nav_bar_admin.dart';
import '../../forgot_password/forgot_password_screen.dart';
import '../../login_success/login_success.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  bool remember = true;
  final List<String> errors = [];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error!);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog();
      return;
    }

    if (username == 'admin' && password == 'admin') {
      var urlAdmin = Uri.parse('$DOTNET_URL_API_BACKEND/Admin/login');
      var bodyAdmin = json.encode({
        'username': username,
        'password': password,
      });
      print(bodyAdmin);
      try {
        http.Response response = await http.post(
          urlAdmin,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: bodyAdmin,
        );

        String? cookieAdmin = response.headers['set-cookie'];
        // Extract the cookie expiration timestamp from the response body
        var responseBody = json.decode(response.body);
        String? cookieExpirationTimestamp =
            responseBody['cookieExpirationTimestamp'];
        if (response.statusCode != 200) {
          throw Exception('Failed to login');
        } else {
          print('Login successful');
        }
        if (cookieAdmin != null && cookieExpirationTimestamp != null) {
          // Save the cookie and expiration timestamp using shared_preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('cookie', cookieAdmin);
          await prefs.setString(
              'cookieExpirationTimestamp', cookieExpirationTimestamp);
          print('Cookie Admin saved: $cookieAdmin');
          print(
              'Cookie expiration timestamp saved for admin: $cookieExpirationTimestamp');
        }
        // else {
        //   // Save the cookie and expiration timestamp using shared_preferences
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('cookie', cookieAdmin!);
        //   await prefs.setString(
        //       'cookieExpirationTimestamp', cookieExpirationTimestamp!);
        //   print('Cookie Admin saved: $cookieAdmin');
        //   print(
        //       'Cookie expiration timestamp saved for admin: $cookieExpirationTimestamp');
        // }

        Navigator.pushReplacementNamed(context, MainScreenAdmin.routeName);
        print(response.body);
      } catch (e) {
        Navigator.pop(context);
        _showErrorDialog();
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
        print(e.toString());
      }
    } else if (username.isNotEmpty != "admin" &&
        password.isNotEmpty != "admin") {
      var url = Uri.parse('$DOTNET_URL_API_BACKEND/User/login');
      var urlNotification =
          Uri.parse('$DOTNET_URL_API_BACKEND/Notification/send/welcome-msg');

      var body = json.encode({
        'username': username,
        'password': password,
      });

      // I want to add Date and time to the notification
      var bodyNotification = json.encode({
        'message':
            "Welcome to Sela\nYou have successfully logged in.\nDate: ${DateTime.now()}\nTime: ${TimeOfDay.now()}",
      });

      print("SignIn Body" + body);
      print("Notification Body" + bodyNotification);
      try {
        http.Response response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        );

        http.Response responseNotification = await http.post(
          urlNotification,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: bodyNotification,
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to login');
        } else {
          print('Login successful');
          // Extract the cookie from the response headers
          String? cookie = response.headers['set-cookie'];
          // Extract the cookie expiration timestamp from the response body
          var responseBody = json.decode(response.body);
          String? cookieExpirationTimestamp =
              responseBody['cookieExpirationTimestamp'];
          if (cookie != null && cookieExpirationTimestamp != null) {
            // Save the cookie and expiration timestamp using shared_preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('cookie', cookie);
            await prefs.setString(
                'cookieExpirationTimestamp', cookieExpirationTimestamp);
            print('Cookie saved: $cookie');
            print(
                'Cookie expiration timestamp saved: $cookieExpirationTimestamp');
          }
        }
        Navigator.pushReplacementNamed(context, LoginSuccessScreen.routeName);
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful'),
          ),
        );
        if (responseNotification.statusCode != 200) {
          throw Exception('Failed to send notification');
        } else {
          print('Notification sent successfully');
        }

        print(response.body);
      } catch (e) {
        Navigator.pop(context);
        _showErrorDialog();
        // show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Failed'),
          ),
        );
        print(e.toString());
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor4,
          icon: const Icon(Icons.sms_failed_outlined),
          iconColor: primaryColor,
          title: const Text('Login Failed'),
          content: const Text(
              'Please check your username or password and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Replace with the route name of your signup screen
              },
              child: const Text('OK'),
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
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // buildEmailFormField(),
          // SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Sign In",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingScreen()),
                );
                login(usernameController.text, passwordController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    return TextFormField(
      onSaved: (newValue) => usernameController.text = newValue!,
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
        labelText: "User Name",
        hintText: "Enter your user name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => passwordController.text = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        // if (value.length >= 8) {
        //   removeError(error: kShortPassError);
        // }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        // else if (value.length < 8) {
        //   addError(error: kShortPassError);
        //   return "";
        // }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
