import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/pages/bottom_navigation_page.dart';
import 'package:ride_spot/utility/colors.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
  });

  @override
  State<AddProductPage> createState() => _TestState();
}

class _TestState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  File? fileImage;
  String? category = '';
  TextEditingController cycleNameController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAddProductForm(),
    );
  }

  dd() {
    context.read<AddProductBloc>().add(GetProduct());
  }

  Widget _buildAddProductForm() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Add Product',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color.fromARGB(251, 255, 132, 0), // Your primary color
                // Color.fromARGB(
                //     255, 255, 191, 0), // A complementary golden shade
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 4,
        backgroundColor: Colors.blue,
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
                //validator: (value) {return},
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Mountain Bike',
                      child: Text(
                        'Mountain Bike',
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                  DropdownMenuItem(
                      value: 'Road Bike',
                      child: Text(
                        'Road Bike',
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                  DropdownMenuItem(
                      value: 'Hybrid',
                      child: Text(
                        'Hybrid',
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                  DropdownMenuItem(
                      value: 'Electric Bikes',
                      child: Text(
                        'Electric Bikes',
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                  DropdownMenuItem(
                      value: "Kids' Bikes",
                      child: Text(
                        "Kids' Bikes",
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                  DropdownMenuItem(
                      value: 'Folding Bikes',
                      child: Text(
                        'Folding Bikes',
                        style: TextStyle(color: CustomColor.primaryColor),
                      )),
                ],
                onChanged: (value) {
                  print(value);
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
                        border: Border.all(
                            width: 1.9, color: CustomColor.primaryColor),
                      ),
                      height: 200,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            state.fileImage!,
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
                        border: Border.all(
                            width: 1.9, color: CustomColor.primaryColor),
                      ),
                      height: 200,
                      child: const Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: CustomColor.primaryColor,
                          ),
                          SizedBox(height: 8),
                          //   CircularProgressIndicator(),
                          Text(
                            'No Image Selected',
                            style: TextStyle(color: CustomColor.primaryColor),
                          ),
                        ],
                      )),
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
                        currentState.fileImage != null) {
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
                        SubmitCycleDetailsEvent event = SubmitCycleDetailsEvent(
                          name: name,
                          brand: brand,
                          price: price,
                          category: category!,
                          description: description,
                        );
                        context.read<AddProductBloc>().add(event);

                        // Wait for the product to be added
                        await Future.delayed(const Duration(milliseconds: 500));

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
                  backgroundColor: CustomColor.primaryColor,
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
