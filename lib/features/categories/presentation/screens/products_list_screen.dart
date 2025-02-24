import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/auth/auth_serviece.dart';
import 'package:ride_spot/auth/modal/product_modal.dart';
import 'package:ride_spot/blocs/add_product_bloc/bloc/add_product_bloc.dart';
import 'package:ride_spot/features/categories/presentation/screens/add_product_screen.dart';
import 'package:ride_spot/features/categories/presentation/screens/edit_product.dart';
import 'package:ride_spot/features/categories/presentation/widgets/products_list_widget.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/small_text_button.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/custom_scaffol_message.dart';
import 'package:ride_spot/utility/navigation.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;
  const ProductPage({super.key, required this.categoryName});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    log('fetching data called');
    context
        .read<AddProductBloc>()
        .add(GetProduct(category: widget.categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.categoryName,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: CustomColor.lightpurple,
        ),
        body: BlocBuilder<AddProductBloc, AddProductState>(
          builder: (context, state) {
            if (state is AddProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ShowAllProduct) {
              if (state.cycles == null || state.cycles!.isEmpty) {
                return GestureDetector(
                  onTap: () {},
                  child: const Center(
                    child: Text('No products found. Tap to refresh.'),
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7,
                ),
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 80),
                itemCount: state.cycles!.length,
                itemBuilder: (context, index) {
                  final product = state.cycles![index];

                  return ProductsListWidget.productCard(
                    imagUrl: product['image_url'][0],
                    funtion: () {},
                    cycleName: product['name'],
                    price: product['price'],
                    //! DeletFunction
                    deleteFunction: () async {
                      bool shouldDelete =
                          await _showDeleteConfirmationDialog(context);

                      if (shouldDelete) {
                        if (mounted) {
                          AuthService authService = AuthService();
                          final documentId = product['documentId'];
                          context
                              .read<AddProductBloc>()
                              .add(DeleteProduct(documentId));
                          // DeleteProduct
                          // setState(() {
                          //   state.cycles!.removeAt(index);
                          // });

                          await authService.deleteCycle(documentId);
                          log('Data deleted for documentId: $documentId');

                          if (context.mounted) {
                            showUpdateNotification(
                                context: context,
                                message: 'Date deleted successful');
                          }

                          // fetchData(); // Refresh the list
                        }
                      }
                    },
                    //! EditFuntion
                    editFuntion: () {
                      final documentId = product['documentId'];
                      Cycles cycles = Cycles.fromMap(product);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return EditProductPage(
                          documetId: documentId,
                          cycles: cycles,
                          category: widget.categoryName,
                        );
                      })).then((_) => fetchData()); // Refresh after edit
                    },
                  );
                },
              );
            }

            return GestureDetector(
              onTap: () => fetchData(),
              child: const Center(
                  child: Text('Something went wrong. Tap to retry.')),
            );
          },
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          backgroundColor: CustomColor.lightpurple,
          onPressed: () {
            CustomNavigation.push(
              context,
              AddProductPage(categoryName: widget.categoryName),
            ).then((_) => fetchData()); // Refresh after returning
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 26,
          ),
        ),
      )
    ]);
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return Center(
              child: Container(
                width: deviceWidth(context) - deviceWidth(context) / 4,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Confirm deletion?',
                      style: TextStyle(
                        decorationThickness: 0,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SmallTextbutton(
                              width: 0.5,
                              textColor: Colors.black,
                              buttomName: 'Cancel',
                              fontweight: 16,
                              voidCallBack: () {
                                Navigator.of(ctx).pop(false);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: SmallTextbutton(
                              width: 0.5,
                              textColor: Colors.black,
                              buttomName: 'Delete',
                              fontweight: 16,
                              voidCallBack: () async {
                                Navigator.of(ctx).pop(true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  Widget buildDialogButton(String text, {bool isDelete = false}) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: TextStyle(color: isDelete ? Colors.red : Colors.black),
      ),
    );
  }
}
