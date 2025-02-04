import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/modal/product_modal.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/utility/colors.dart';

class EditProductPage extends StatefulWidget {
  final String documetId;
  final Cycles cycles;
  const EditProductPage(
      {super.key, required this.documetId, required this.cycles});

  @override
  State<EditProductPage> createState() => _TestState();
}

class _TestState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> networkImages = []; // For existing images from network
  List<File> newImages = []; // For newly added images
  String? category = '';
  TextEditingController cycleNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAddProductForm(),
    );
  }

  fetchData() {
    cycleNameController.text = widget.cycles.cycleName;
    brandController.text = widget.cycles.brand;
    priceNameController.text = widget.cycles.price.toString();
    descriptionController.text = widget.cycles.description;
    networkImages = widget.cycles.images;
    category = widget.cycles.category;
    print('///    llllll   ${networkImages.length} hhhh ${newImages.length}');
  }

  dd() {
    context.read<AddProductBloc>().add(GetProduct());
  }

  // Add this method to handle new image selection
  void _handleImageSelected(AddProductState state) {
    if (state is ShowAddProductImage) {
      setState(() {
        newImages.add(state.fileImage);
      });
    }
  }

  Widget _buildAddProductForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Edit Cycle',
          textAlign: TextAlign.center,
        )),
      ),
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
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 18, color: CustomColor.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                //validator: (value) {return},
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Mountain Bike', child: Text('Mountain Bike')),
                  DropdownMenuItem(
                      value: 'Road Bike', child: Text('Road Bike')),
                  DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
                  DropdownMenuItem(
                      value: 'Electric Bikes', child: Text('Electric Bikes')),
                  DropdownMenuItem(
                      value: "Kids' Bikes", child: Text("Kids' Bikes")),
                  DropdownMenuItem(
                      value: 'Folding Bikes', child: Text('Folding Bikes')),
                ],
                onChanged: (value) {
                  category = value;
                },
              ),
              const SizedBox(height: 16),
              _buildImageSection(),
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
                      (networkImages.isNotEmpty || newImages.isNotEmpty)) {
                    if (category!.isNotEmpty) {
                      SubmitCycleDetailsOnUpdateEvent event =
                          SubmitCycleDetailsOnUpdateEvent(
                        name: cycleNameController.text,
                        brand: brandController.text,
                        price: int.tryParse(priceNameController.text) ?? 100,
                        category: category!,
                        description: descriptionController.text,
                        documentId: widget.documetId,
                        networkImages: networkImages,
                        newImages: newImages,
                      );
                      context.read<AddProductBloc>().add(event);

                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BottomNavigationPage(pageIndex: 2),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a category')),
                      );
                    }
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
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Update Product',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {
        _handleImageSelected(state);
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 1.9,
                  color: CustomColor.primaryColor,
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: networkImages.length + newImages.length + 1,
                itemBuilder: (context, index) {
                  // Add image button at the end
                  if (index == networkImages.length + newImages.length) {
                    return GestureDetector(
                      onTap: () {
                        if (networkImages.length + newImages.length < 5) {
                          context.read<AddProductBloc>().add(AddProductImage());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Maximum 5 images allowed'),
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
                            color: CustomColor.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_photo_alternate,
                              size: 30,
                              color: CustomColor.primaryColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add Image (${networkImages.length + newImages.length}/5)',
                              style: const TextStyle(
                                color: CustomColor.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Show existing network images first
                  if (index < networkImages.length) {
                    return _buildImageItem(
                      isNetwork: true,
                      source: networkImages[index],
                      index: index,
                    );
                  }

                  // Show newly added images
                  final newImageIndex = index - networkImages.length;
                  return _buildImageItem(
                    isNetwork: false,
                    source: newImages[newImageIndex],
                    index: index,
                  );
                },
              ),
            ),
            if (networkImages.isEmpty && newImages.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Please add at least one image',
                  style: TextStyle(
                    color: Color.fromARGB(255, 241, 95, 84),
                    fontSize: 12,
                  ),
                ),
              ),
            // Show image count
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${networkImages.length + newImages.length} of 5 images selected',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageItem({
    required bool isNetwork,
    required dynamic source,
    required int index,
  }) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120, // Add fixed height
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: CustomColor.primaryColor,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: isNetwork
                ? Image.network(
                    source,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  )
                : Image.file(
                    source,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isNetwork) {
                  networkImages.removeAt(index);
                } else {
                  newImages.removeAt(index - networkImages.length);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
  }
}
