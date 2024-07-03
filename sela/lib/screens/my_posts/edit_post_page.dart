import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/my_post_model.dart';
import '../../../utils/env.dart';
import '../../components/custom_suffix_icon.dart';
import '../../components/form_error.dart';
import '../../size_config.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../create_post/components/post_images_form.dart';

class EditPostPage extends StatefulWidget {
  final MyPost post;

  static String routeName = '/edit_post';

  const EditPostPage({Key? key, required this.post}) : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _aboutController;
  late TextEditingController _socialLinksController;

  String _selectedType = 'Organization';
  List<String> _selectedTags = [];
  List<String> _selectedProviders = [];
  List<String> _imageUrls = [];

  final List<String> _types = ["Organization", "Individual"];
  final List<String> _tags = [
    "Learning",
    "Volunteering",
    "Health",
    "Tech",
    "Finance",
    "Entertainment",
    "Sports",
    "Food",
    "Fashion",
    "Travel"
  ];
  final List<String> _providers = [
    "Fawry",
    "CIB",
    "Vodafone",
    "Orange",
    "Etisalat",
    "Aman",
    "Masary"
  ];

  final List<String> errors = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.post.name);
    // _selectedType = widget.post.type == 0 ? 'Organization' : 'Individual';
    _titleController = TextEditingController(text: widget.post.title);
    _descriptionController =
        TextEditingController(text: widget.post.description);
    _aboutController = TextEditingController(text: widget.post.about);
    _socialLinksController =
        TextEditingController(text: widget.post.socialLinks);
    _selectedTags = widget.post.tags ?? [];
    _selectedProviders = widget.post.providers ?? [];
    _imageUrls = widget.post.imageUrls ?? [];
  }

  Future<void> _updatePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Convert type to an integer based on selectedType
    int type = _selectedType == 'Organization' ? 0 : 1;

    // Convert _selectedTags and _selectedProviders to lists of strings
    List<String> tags = List<String>.from(_selectedTags);
    List<String> providers = List<String>.from(_selectedProviders);

    // Create a new Post object
    final updatedPost = {
      'imageUrLs': _imageUrls,
      'name': _nameController.text,
      'type': type,
      'tags': tags,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'providers': providers,
      'about': _aboutController.text,
      'socialLinks': _socialLinksController.text,
    };

    // Convert the Post object to JSON string
    final jsonPost = jsonEncode(updatedPost);

    // Retrieve the cookie from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    // Send the data to the endpoint
    final url =
        Uri.parse('$DOTNET_URL_API_BACKEND/Post/update/${widget.post.postId}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
      body: jsonPost,
    );

    print(response.body);
    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post updated successfully')),
      );
      Navigator.of(context).pop(true); // Return true to indicate success
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _aboutController.dispose();
    _socialLinksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PostImagesForm(
                  onNext: (imageUrls) {
                    setState(() {
                      _imageUrls = imageUrls;
                    });
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _types.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MultiSelectDialogField(
                  items: _tags.map((tag) => MultiSelectItem(tag, tag)).toList(),
                  title: const Text('Tags'),
                  buttonText: const Text('Select Tags'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  listType: MultiSelectListType.CHIP,
                  backgroundColor: Colors.white,
                  selectedColor: kPrimaryColor,
                  itemsTextStyle: TextStyle(color: textColor1),
                  searchable: true,
                  selectedItemsTextStyle: const TextStyle(color: Colors.white),
                  colorator: (selected) {
                    return selected != null ? kPrimaryColor : backgroundColor1;
                  },
                  confirmText: Text(
                    'Save',
                    style: TextStyle(
                      color: textColor1,
                    ),
                  ),
                  cancelText: Text(
                    'Cancel',
                    style: TextStyle(
                      color: textColor1,
                    ),
                  ),
                  barrierColor: Colors.black.withOpacity(0.7),
                  unselectedColor: backgroundColor1,
                  decoration: BoxDecoration(
                    border: Border.all(color: textColor2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedTags = results.cast<String>();
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    chipColor: kPrimaryColor,
                    textStyle: const TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: (value) {
                      setState(() {
                        _selectedTags.remove(value);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                MultiSelectDialogField(
                  items: _providers
                      .map((provider) => MultiSelectItem(provider, provider))
                      .toList(),
                  title: const Text('Providers'),
                  buttonText: const Text('Select Providers'),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  listType: MultiSelectListType.CHIP,
                  backgroundColor: Colors.white,
                  selectedColor: kPrimaryColor,
                  itemsTextStyle: TextStyle(color: textColor1),
                  searchable: true,
                  selectedItemsTextStyle: const TextStyle(color: Colors.white),
                  colorator: (selected) {
                    return selected != null ? kPrimaryColor : backgroundColor1;
                  },
                  confirmText: Text(
                    'Save',
                    style: TextStyle(
                      color: textColor1,
                    ),
                  ),
                  cancelText: Text(
                    'Cancel',
                    style: TextStyle(
                      color: textColor1,
                    ),
                  ),
                  barrierColor: Colors.black.withOpacity(0.7),
                  unselectedColor: backgroundColor1,
                  decoration: BoxDecoration(
                    border: Border.all(color: textColor2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onConfirm: (results) {
                    setState(() {
                      _selectedProviders = results.cast<String>();
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    chipColor: kPrimaryColor,
                    textStyle: const TextStyle(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: (value) {
                      setState(() {
                        _selectedProviders.remove(value);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _aboutController,
                  decoration: const InputDecoration(
                    labelText: 'About',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter about information';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _socialLinksController,
                  decoration: const InputDecoration(
                    labelText: 'Social Links',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter social links';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FormError(errors: errors),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updatePost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                    backgroundColor: kPrimaryColor,
                  ),
                  child: const Text(
                    'Update Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
