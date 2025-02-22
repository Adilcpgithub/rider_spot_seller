import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/features/categories/presentation/screens/categories_list_screen.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/custom_scaffol_message.dart';
import 'package:ride_spot/utility/navigation.dart';

class AddCategoryScreen extends StatefulWidget {
  final String? categoryId; // If null -> Add mode, Else -> Edit mode
  final String? initialName;
  final String? initialImageUrl;
  const AddCategoryScreen(
      {super.key, this.categoryId, this.initialName, this.initialImageUrl});

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  File? _selectedImageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String? _imageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  void submitCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImageFile != null || _imageUrl != null) {
        final categoryEvent = widget.categoryId == null
            ? AddCategoryEvent(
                categoryName: _categoryController.text,
                imageFile: _selectedImageFile)
            : UpdateCategoryEvent(
                categoryId: widget.categoryId!,
                categoryName: _categoryController.text,
                imageFile: _selectedImageFile,
                imageUrl: _imageUrl);

        BlocProvider.of<CategoryBloc>(context).add(categoryEvent);
      } else {
        showUpdateNotification(
            context: context,
            message: 'Please select an image',
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
  void initState() {
    if (widget.categoryId != null) {
      // Edit Mode: Pre-fill Data
      _categoryController.text = widget.initialName ?? '';
      _imageUrl = widget.initialImageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.categoryId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? "Edit Category" : "Add New Category",
          style: const TextStyle(color: Colors.white),
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
                    if (value.length > 14) {
                      return 'Name is too long';
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
              const Text(
                "UPLOAD IMAGE",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImageFile != null
                      ? Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(_selectedImageFile!,
                                height: 180, width: 200, fit: BoxFit.cover),
                          ),
                          Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImageFile = null;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 25,
                                  )))
                        ])
                      : _imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                _imageUrl!,
                                height: 180,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 180,
                              width: 200,
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
                        message: 'Category is existing!',
                        color: Colors.green);
                  } else if (state is CategoryAddedSuccess ||
                      state is CategoryUpdatedSuccess) {
                    showUpdateNotification(
                        context: context,
                        message: isEditMode
                            ? 'Category updated successfully!'
                            : 'Category added successfully!',
                        color: Colors.green);

                    CustomNavigation.pushReplacement(
                        context, const CategoriesListScreen());
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
                    child: SizedBox(
                      height: 45,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              CustomColor.lightpurple, // Change button color
                          foregroundColor: Colors.white, // Change text color

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                        ),
                        onPressed:
                            state is CategoryLoading ? null : submitCategory,
                        child: state is CategoryLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : Text(isEditMode ? "UPDATE" : "UPLOAD"),
                      ),
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
