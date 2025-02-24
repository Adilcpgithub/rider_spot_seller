import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/features/categories/presentation/screens/products_list_screen.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/navigation.dart';

class AddProductPage extends StatefulWidget {
  final String categoryName;
  const AddProductPage({super.key, required this.categoryName});

  @override
  State<AddProductPage> createState() => _TestState();
}

class _TestState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  List<File> selectedImages = [];
  TextEditingController cycleNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _handleImageSelected(AddProductState state) {
    if (state is ShowAddProductImage) {
      setState(() {
        selectedImages.add(state.fileImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add ${widget.categoryName}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: CustomColor.lightpurple,
      ),
      body: _buildAddProductForm(),
    );
  }

  Widget _buildAddProductForm() {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: cycleNameController,
                decoration: const InputDecoration(
                  labelText: 'Cycle Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cycle name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: brandController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cycle Brand';
                  }
                  return null;
                },
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
                decoration: InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 18, color: CustomColor.lightpurple),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              BlocConsumer<AddProductBloc, AddProductState>(
                listener: (context, state) {
                  _handleImageSelected(state);
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1.9,
                            color: CustomColor.lightpurple,
                          ),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == selectedImages.length) {
                              // Add image button
                              return GestureDetector(
                                onTap: () {
                                  if (selectedImages.length < 5) {
                                    // Limit to 5 images
                                    context
                                        .read<AddProductBloc>()
                                        .add(AddProductImage());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Maximum 5 images allowed'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: CustomColor.lightpurple,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 30,
                                        color: CustomColor.lightpurple,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Add Image (${selectedImages.length}/5)',
                                        style: TextStyle(
                                          color: CustomColor.lightpurple,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Show selected image
                            return Stack(
                              children: [
                                Container(
                                  width: 120,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: CustomColor.lightpurple,
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.file(
                                      selectedImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      if (selectedImages.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Add at least one image',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                onChanged: (value) {
                  _formKey.currentState!.validate();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      selectedImages.isNotEmpty) {
                    SubmitCycleDetailsEvent event = SubmitCycleDetailsEvent(
                        name: cycleNameController.text,
                        brand: brandController.text,
                        price: int.tryParse(priceNameController.text) ?? 0,
                        category: widget.categoryName,
                        description: descriptionController.text,
                        images: selectedImages);
                    context.read<AddProductBloc>().add(event);

                    // Show loading indicator

                    // Wait for images to upload
                    // await Future.delayed(const Duration(seconds: 2));

                    // Navigate back
                    // Navigator.of(context).pop();
                    log(' data added  ');
                    Navigator.of(context).pop();
                    // CustomNavigation.pushReplacement(
                    //     context,
                    //     ProductPage(
                    //       categoryName: widget.categoryName,
                    //     ));
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         const BottomNavigationPage(pageIndex: 2),
                    //   ),
                    //   (route) => false,
                    // );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please fill all fields and add at least one image'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.lightpurple,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
