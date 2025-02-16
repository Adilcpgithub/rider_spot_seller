import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth/modal/product_modal.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/pages/edit_product.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  void fetchData() {
    context.read<AddProductBloc>().add(GetProduct());
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductsList();
  }

  Widget _buildProductsList() {
    return Scaffold(
      body: BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) {
          if (state is ShowAllProduct && state.cycles!.isEmpty) {
            log('cycle is  empty');

            return GestureDetector(
                onTap: () async {
                  fetchData();
                },
                child: const Center(child: Text('No products found.')));
            // print(state.cycles!.length);
          }

          if (state is ShowAllProduct && state.cycles != null) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7, // Adjust this to reduce overflow
              ),
              padding: const EdgeInsets.all(16),
              itemCount: state
                  .cycles!.length, // Replace with the actual number of products
              itemBuilder: (context, index) {
                final product = state.cycles![index];

                return productCard(
                    //!
                    imagUrl: product['image_url'][0],
                    funtion: () {},
                    cycleName: product['name'],
                    price: product['price'],
                    deleteFunction: () async {
                      log('Delete initiated');
                      bool shouldDelete =
                          await _showDeleteConfirmationDialog(context);

                      if (shouldDelete) {
                        if (mounted) {
                          AuthService authService = AuthService();
                          final documentId = product['documentId'];

                          setState(() {
                            state.cycles!.removeAt(index);
                          });

                          await authService.deleteCycle(documentId);
                          log('Data deleted for documentId: $documentId');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Your data has been removed'),
                              ),
                            );
                          }

                          if (context.mounted) {
                            context.read<AddProductBloc>().add(GetProduct());
                          }
                        }
                      } else {
                        log('Deletion cancelled');
                      }
                    },
                    editFuntion: () {
                      final documentId = product['documentId'];
                      Cycles cycles = Cycles.fromMap(product);

                      log('ssssssssssssssss');
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return EditProductPage(
                          documetId: documentId,
                          cycles: cycles,
                        );
                      }));
                    });
              },
            );
          } else if (state is ShowAllProduct && state.cycles!.isEmpty) {
            return const Center(child: Text('no data .'));
          } else if (state is AddImageLoading) {
            log('cycle is empty');
            return const Center(child: CircularProgressIndicator());
          } else {
            return GestureDetector(
                onTap: () => context.read<AddProductBloc>().add(GetProduct()),
                child: const Center(child: Text('No products found.')));
          }
        },
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: CustomColor.lightpurple,
          title: const Center(
              child: Text(
            'Confirm Deletion',
            style: TextStyle(
              fontSize: 22, // Larger font for emphasis
              fontWeight: FontWeight.bold,
              color: Colors.white, // Contrasts well with the gradient
              shadows: [
                // Shadow(
                //   offset: Offset(2, 2),
                //   blurRadius: 1,
                //   color: Colors.black26, // Subtle shadow for depth
                // ),
              ],
            ),
          )),
          content: const Text(
            'Are you sure you want to delete this cycle?',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false); // Return false on cancel
              },
              child: Container(
                  padding: const EdgeInsetsDirectional.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9)),
                  child: const Text('Cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true); // Return true on confirm
              },
              child: Container(
                padding: const EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9)),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false; // Return false if dialog is dismissed
  }
}

Widget productCard(
    {required String imagUrl,
    required VoidCallback funtion,
    required String cycleName,
    required int price,
    required VoidCallback deleteFunction,
    required VoidCallback editFuntion}) {
  return GestureDetector(
    onTap: () => funtion,
    child: Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 221, 221),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imagUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // return const Stack(
                  //   children: [
                  //     SizedBox(
                  //       height: 100,
                  //     ),
                  //     Positioned(
                  //         child: Center(
                  //       child: Padding(
                  //         padding: EdgeInsets.only(top: 20),
                  //         child: Icon(
                  //           Icons.cloud_off,
                  //           size: 50,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // );
                  return const Center(
                      child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4),
                    child: Text(
                      cycleName, // Replace with actual product name
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      price.toString(), // Replace with actual price
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
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
    ),
  );
}
