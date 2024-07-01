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
    _fetchSearchResults(_searchController.text);
  }

  Future<void> _fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _loading = true;
    });

    final response = await http
        .get(Uri.parse('$DOTNET_URL_API_BACKEND/Post/search?query=$query'));

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(20)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search product",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _searchResults.isEmpty
                      ? const Center(child: Text('No results found'))
                      : Flexible(
                          child: ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final organization = _searchResults[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(20),
                                  vertical: getProportionateScreenHeight(10),
                                ),
                                child: OrganizationCard(
                                  // Adjusted condition to check for null or empty list
                                  logo: organization.imageUrls != null &&
                                          organization.imageUrls!.isNotEmpty
                                      ? organization.imageUrls![0]
                                      : 'https://via.placeholder.com/150',
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
                ),
        ],
      ),
    );
  }
}
