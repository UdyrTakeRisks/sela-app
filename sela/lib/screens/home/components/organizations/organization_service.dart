import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sela/models/Organizations.dart';

import '../../../../utils/env.dart';

class OrganizationService {
  Future<List<Organization>> fetchOrganizations() async {
    final response =
        await http.get(Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/all/orgs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((org) => Organization.fromJson(org))
          .take(5) // Take only the first 5 organizations
          .toList();
    } else {
      throw Exception('Failed to load organizations');
    }
  }
}
