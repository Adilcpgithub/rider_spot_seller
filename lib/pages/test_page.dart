import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _HomeState();
}

class _HomeState extends State<Test> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  int _currentIndex = 0;
  final _formKey = GlobalKey<FormState>();
  File? fileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? _buildAddProductForm() : _buildProductsList(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Add Product',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded),
              label: 'My Products',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildAddProductForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Cycle'),
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
                decoration: const InputDecoration(
                  labelText: 'Cycle Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(width: 1.9),
                ),
                height: 200,
                child: Center(
                  child: fileImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No Image Selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            fileImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  File? pickedImage = await uploadImage();
                  if (pickedImage != null) {
                    setState(() {
                      fileImage = pickedImage;
                    });
                  }
                },
                icon: const Icon(Icons.add_photo_alternate),
                label: Text(
                    fileImage == null ? 'Add Product Images' : 'Change Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add your submit logic here
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Add Product',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Replace with your actual products length
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[400],
            elevation: 7,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: Image.asset(
                      'asset/NutraNest.png', // Replace with actual image
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mountain Bike XYZ', // Replace with actual name
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Brand Name', // Replace with actual brand
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹25,000', // Replace with actual price
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Mountain Bike', // Replace with actual category
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description of the product goes here...', // Replace with actual description
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Edit Button
                          OutlinedButton.icon(
                            onPressed: () {
                              _showEditDialog(context);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Delete Button
                          OutlinedButton.icon(
                            onPressed: () {
                              _showDeleteConfirmation(context);
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text(
            'Are you sure you want to delete this product?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle delete logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

Future<File?> uploadImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile?.path == null) {
    return null;
  }
  if (pickedFile != null) {
    print(pickedFile.path.toString());
  } else {
    return null;
  }

  File? imageFile = File(pickedFile.path);
  return imageFile;
  // return await uploadImageToFireStore(imageFile);
}

Future<void> addProduct(
    {required String sellerId,
    required String cycleName,
    required String brandName,
    required String category,
    required double price}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'nutranest-a6417.firebasestorage.app');
  try {
    await _firestore.collection('products').add(
      {
        'sellerId': sellerId,
        'cycleName': cycleName,
        'brandName': brandName,
        'category': category,
        'productName': cycleName,
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      },
    );
  } catch (e) {
    print('Error adding product: $e');
  }
}

/**
 
  Future<String?> uploadImageToFireStore(File imageFile) async {
    log('1');
    try {
      final ref = _storage
          .ref()
          .child('users/${UserStatus.userIdFinal}/profileImage.jpg');
      final uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      log('2');
      // Get the download URL
      final imageUrl = await ref.getDownloadURL();
      log('3');

      // Save the URL to Firestore
      try {
        await _firestore.collection('users').doc(UserStatus.userIdFinal).set({
          'profileImage': imageUrl,
        }, SetOptions(merge: true));
        log('4');
        return imageUrl;
      } catch (e) {
        log('error coccoure when store image url in firestore :$e');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }
 */