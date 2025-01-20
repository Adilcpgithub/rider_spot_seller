import 'dart:developer';
import 'dart:io';
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
  String fileImage = '';
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
    priceNameController.text = widget.cycles.price;
    descriptionController.text = widget.cycles.description;
    fileImage = widget.cycles.fileImage;
    category = widget.cycles.category;
  }

  dd() {
    context.read<AddProductBloc>().add(GetProduct());
  }

  Widget _buildAddProductForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: const Text('Add New Cycle              ')),
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
              BlocBuilder<AddProductBloc, AddProductState>(
                  builder: (context, state) {
                if (state is ShowAddProductImage) {
                  return GestureDetector(
                    onTap: () async {
                      context.read<AddProductBloc>().add(AddProductImage());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(width: 1.9),
                      ),
                      height: 200,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            state.fileImage as File,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      context.read<AddProductBloc>().add(AddProductImage());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(width: 1.9),
                      ),
                      height: 200,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            fileImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }),
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
                  if (_formKey.currentState!.validate()) {
                    // if ((state as ShowAddProductImage).fileImage!=null){}
                    final currentState = context.read<AddProductBloc>().state;
                    if (currentState is ShowAddProductImage &&
                            currentState.fileImage != null ||
                        fileImage.isNotEmpty) {
                      if (category!.isNotEmpty) {
                        print('successfully workging submittion');

                        String name = cycleNameController.text;
                        String brand = brandController.text;
                        String price = priceNameController.text;
                        String description = descriptionController.text;
                        log(name);
                        log(brand);
                        log(price);
                        log(description);
                        SubmitCycleDetailsOnUpdateEvent event =
                            SubmitCycleDetailsOnUpdateEvent(
                                name: name,
                                brand: brand,
                                price: price,
                                category: category!,
                                description: description,
                                documentId: widget.documetId,
                                images: []);
                        context.read<AddProductBloc>().add(event);

                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BottomNavigationPage(pageIndex: 2),
                          ),
                          (route) => false, // This removes all previous routes
                        );
                      } else {
                        print('please select category');
                      }
                    } else {
                      print('please select image');
                    }
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
}
