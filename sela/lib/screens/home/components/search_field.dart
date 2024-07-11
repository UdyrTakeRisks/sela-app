import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/env.dart';
import '../../details/details_screen.dart';
import 'organizations/organization_card.dart'; // Adjust the import path as needed

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Organization> _searchResults = [];
  bool _loading = false;
  String _selectedFilter = 'name';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _fetchSearchResults(_searchController.text, _selectedFilter);
  }

  Future<void> _fetchSearchResults(String query, String filterBy) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    final response = await http.get(
      Uri.parse(
          '$DOTNET_URL_API_BACKEND/Post/search?query=$query&filterBy=$filterBy'),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _searchResults =
            data.map((item) => Organization.fromJson(item)).toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search query",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by:',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                      _onSearchChanged();
                    });
                  },
                  items: <String>['name', 'tag']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.capitalize(),
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                    );
                  }).toList(),
                  underline: Container(),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _searchResults.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final organization = _searchResults[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(10),
                                ),
                                child: OrganizationCard(
                                  logo: organization.imageUrls != null &&
                                          organization.imageUrls!.isNotEmpty
                                      ? organization.imageUrls![0]
                                      : '',
                                  name: organization.name,
                                  title: organization.title,
                                  tags: organization.tags!.take(3).toList(),
                                  press: () {
                                    Navigator.pushNamed(
                                      context,
                                      DetailsScreen.routeName,
                                      arguments: DetailsArguments(
                                        organization: organization,
                                        index: index,
                                      ),
                                    );
                                  },
                                  index: index,
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this == null) {
      throw ArgumentError("String cannot be null");
    }
    if (this.isEmpty) {
      return "";
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}
