// lib/screens/home/components/individuals/individual_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../models/individual.dart';
import '../../../../utils/env.dart';

class IndividualService {
  Future<List<Individual>> fetchIndividuals() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/all/individuals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Individual> individuals =
          jsonData.map((item) => Individual.fromJson(item)).toList();
      return individuals;
    } else if (response.statusCode == 204) {
      return [];
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load individuals');
    }
  }
}
