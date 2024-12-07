import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';

import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<AddProductBloc>().add(GetProduct());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }

  Widget _buildProductsList() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: const Text('My Products')),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) {
          if (state is ShowAllProduct) {
            log('cycle not empty');
            // print(state.cycles!.length);
          }

          if (state is ShowAllProduct && state.cycles != null) {
            return Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.6, // Adjust this to reduce overflow
                ),
                padding: const EdgeInsets.all(16),
                itemCount: state.cycles!
                    .length, // Replace with the actual number of products
                itemBuilder: (context, index) {
                  final product = state.cycles![index];

                  return _ProductCard(
                      imagUrl: product['image_url'],
                      funtion: () {},
                      cycleName: product['name'],
                      price: product['price'],
                      deleteFunction: () async {
                        print('dddddddddd');
                        AuthService authService = AuthService();
                        print('${product['documentId']}');
                        state.cycles!.removeAt(index);
                        await authService.deleteCycle(product['documentId']);
                      },
                      editFuntion: () {
                        print('ddd');
                      });
                },
              ),
            );
          } else if (state is AddImageLoading) {
            log('cycle is empty');
            return Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
                onRefresh: () async {
                  return context.read<AddProductBloc>().add(GetProduct());
                },
                child: GestureDetector(
                    onTap: () =>
                        context.read<AddProductBloc>().add(GetProduct()),
                    child: const Center(child: Text('No products found.'))));
          }
        },
      ),
    );
  }
}
/** 
   print('Tapped on item $index');
                context.read<AddProductBloc>().add(GetProduct());
*/

Widget _ProductCard(
    {required String imagUrl,
    required VoidCallback funtion,
    required String cycleName,
    required String price,
    required VoidCallback deleteFunction,
    required VoidCallback editFuntion}) {
  return GestureDetector(
    onTap: () => funtion,
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imagUrl, // Replace with the actual image
                height: 100, // Adjust to reduce height
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Stack(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Positioned(
                          child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Icon(
                            Icons.cloud_off,
                            size: 50,
                          ),
                        ),
                      ))
                    ],
                  );
                },
              ),
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    cycleName, // Replace with actual product name
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    price, // Replace with actual price
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('ssss');
                      },
                      child: IconButton(
                        onPressed: deleteFunction,
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: editFuntion,
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
