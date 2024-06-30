import 'package:flutter/material.dart';
import 'package:sela/components/default_button.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  static String routeName = "/help_center";

  const HelpCenterPage({Key? key}) : super(key: key);

  void _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri.parse("mailto:$email");

    try {
      if (await canLaunchUrl(_emailLaunchUri)) {
        await launchUrl(_emailLaunchUri);
      } else {
        throw 'Could not launch $_emailLaunchUri';
      }
    } catch (e) {
      print('Error launching email: $e');
      // Handle error gracefully, e.g., show an alert or log the error for debugging.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Center'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.support_agent_rounded,
                    size: 300,
                    color: primaryColor,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const Text(
                          'How can we help you?',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Text(
                          'If you need help, please feel free to contact us. We are here to help you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Or you want to report a bug or usurious user, please email us ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: DefaultButton(
              press: () {
                _launchEmail(
                    'support@example.com'); // Replace with your support email
              },
              text: 'Email Support',
            ),
          ),
        ],
      ),
    );
  }
}
