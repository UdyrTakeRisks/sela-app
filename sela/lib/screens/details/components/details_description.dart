import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/env.dart';

class OrganizationDescription extends StatefulWidget {
  const OrganizationDescription({
    Key? key,
    required this.organization,
    required this.pressOnSeeMore,
  }) : super(key: key);

  final Organization organization;
  final GestureTapCallback pressOnSeeMore;

  @override
  State<OrganizationDescription> createState() =>
      _OrganizationDescriptionState();
}

class _OrganizationDescriptionState extends State<OrganizationDescription> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString('cookie');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookies!,
      };

      var url = Uri.parse(
          '$DOTNET_URL_API_BACKEND/Post/is-saved/${widget.organization.id}');

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Parse the response body to determine if the post is saved
        var responseBody = response.body;
        var saved = responseBody.toLowerCase() == 'true';

        setState(() {
          isSaved = saved;
        });
      } else {
        throw Exception('Failed to fetch save status');
      }
    } catch (e) {
      print('Error checking save status: $e');
    }
  }

  Future<void> _toggleSaveStatus() async {
    setState(() {
      isSaved = !isSaved;
    });

    final endpoint = isSaved
        ? '$DOTNET_URL_API_BACKEND/Post/save/${widget.organization.id}'
        : '$DOTNET_URL_API_BACKEND/Post/un-save/${widget.organization.id}';

    final method = isSaved ? 'POST' : 'DELETE';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString('cookie');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookies!,
      };

      var url = Uri.parse(endpoint);
      http.Response response;

      if (method == 'POST') {
        response = await http.post(url, headers: headers);
      } else {
        response = await http.delete(url, headers: headers);
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isSaved ? 'Saved' : 'Unsaved')),
        );
      } else {
        throw Exception('Failed to update save status');
      }
    } catch (e) {
      setState(() {
        isSaved = !isSaved; // Revert the save status on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update save status. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Text(
                  widget.organization.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(64),
                ),
                child: Text(
                  widget.organization.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.ios_share_rounded),
                color: Colors.grey,
                onPressed: () async {
                  await Share.share(
                    'Check out this organization: ${widget.organization.name}\nTitle: ${widget.organization.title}\nDescription: ${widget.organization.description}\nLink: ${widget.organization.socialLinks}',
                  );
                },
              ),
              IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                color: Colors.grey,
                onPressed: _toggleSaveStatus,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
