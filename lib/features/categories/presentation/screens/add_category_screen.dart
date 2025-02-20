import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/custom_scaffol_message.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void clearFields() {
    setState(() {
      _formKey.currentState?.reset(); // Reset form state
      _categoryController.clear(); // Clear text field
      _imageFile = null; // Clear image
    });
  }

  void submitCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFile != null) {
        _categoryController.clear();
        BlocProvider.of<CategoryBloc>(context).add(
          AddCategoryEvent(
            categoryName: _categoryController.text,
            imageFile: _imageFile,
          ),
        );
      } else {
        showUpdateNotification(
            context: context,
            message: 'Please select  image',
            color: Colors.green[400]);
      }
    } else {
      showUpdateNotification(
          context: context,
          message: 'Please enter category name',
          color: Colors.green[400]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Category",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColor.lightpurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("CATEGORY NAME",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters long';
                    }
                    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                      return 'Only alpha characters are allowed';
                    }
                    return null;
                  },
                  controller: _categoryController,
                  decoration:
                      const InputDecoration(hintText: "Enter category name"),
                ),
              ),
              const SizedBox(height: 60),
              const Text("UPLOAD IMAGE",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(_imageFile!,
                                height: 250, width: 250, fit: BoxFit.cover),
                          ),
                          Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _imageFile = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 25,
                                  )))
                        ])
                      : Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Icon(
                            Icons.add_a_photo,
                            size: 55,
                            color: CustomColor.lightpurple,
                          )),
                        ),
                ),
              ),
              const SizedBox(height: 50),
              BlocConsumer<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  if (state is CategoryAlreadExist) {
                    showUpdateNotification(
                        context: context,
                        message: 'already exists!!',
                        color: Colors.green);
                  } else if (state is CategoryAddedSuccess) {
                    showUpdateNotification(
                        context: context,
                        message: 'Category added successfully!',
                        color: Colors.green);
                    clearFields();
                    Navigator.of(context).pop();
                  } else if (state is CategoryAddedFailure) {
                    showUpdateNotification(
                        context: context,
                        message: 'something went wrong ',
                        color: Colors.green);
                  }
                },
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            CustomColor.lightpurple, // Change button color
                        foregroundColor: Colors.white, // Change text color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      onPressed:
                          state is CategoryLoading ? null : submitCategory,
                      child: state is CategoryLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("UPLOAD"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
