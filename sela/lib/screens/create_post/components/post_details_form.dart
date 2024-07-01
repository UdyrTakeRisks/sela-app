import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sela/components/custom_suffix_icon.dart';
import 'package:sela/components/form_error.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/constants.dart';

import '../../../utils/colors.dart';

class PostDetailsForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const PostDetailsForm({super.key, required this.onSubmit});

  @override
  PostDetailsFormState createState() => PostDetailsFormState();
}

class PostDetailsFormState extends State<PostDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _aboutController = TextEditingController();
  final _socialLinksController = TextEditingController();

  String _selectedType = 'Organization';
  List<String> _selectedTags = [];
  List<String> _selectedProviders = [];

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

  Map<String, dynamic> collectFormData() {
    return {
      'name': _nameController.text,
      'type': _selectedType,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'tags': _selectedTags,
      'providers': _selectedProviders,
      'about': _aboutController.text,
      'socialLinks': _socialLinksController.text,
    };
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                // hintText: "Enter name of Individual/Organization",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
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
            FormError(errors: errors)
          ],
        ),
      ),
    );
  }
}
