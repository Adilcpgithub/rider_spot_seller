import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';

class ProductsListWidget {
  static Widget productCard(
      {required String imagUrl,
      required VoidCallback funtion,
      required String cycleName,
      required int price,
      required VoidCallback deleteFunction,
      required VoidCallback editFuntion}) {
    return GestureDetector(
      onTap: () => funtion,
      child: Stack(
        children: [
          Card(
            elevation: 7,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 133,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    //  border: Border.all(width: 0.5, color: CustomColor.lightpurple),
                    image: DecorationImage(
                      image: AssetImage(
                        appLogo(),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
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
                        return const Center(
                            child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            cycleName.replaceFirst(
                                cycleName[0],
                                cycleName[0]
                                    .toUpperCase()), // Replace with actual product name
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '  ₹ ${price.toString()}', // Replace with actual price
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {},
                          //       child: IconButton(
                          //         onPressed: deleteFunction,
                          //         icon: Container(
                          //           decoration: BoxDecoration(
                          //             color: Colors.red[200],
                          //             borderRadius: BorderRadius.circular(12),
                          //           ),
                          //           child: const Padding(
                          //             padding: EdgeInsets.all(8.0),
                          //             child: Icon(
                          //               Icons.delete,
                          //               color: Colors.red,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     IconButton(
                          //       onPressed: editFuntion,
                          //       icon: Container(
                          //         decoration: BoxDecoration(
                          //           color: Colors.green[200],
                          //           borderRadius: BorderRadius.circular(12),
                          //         ),
                          //         child: const Padding(
                          //           padding: EdgeInsets.all(8.0),
                          //           child: Icon(
                          //             Icons.edit,
                          //             color: Colors.green,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 38,
              right: 4,
              child: PopupMenuButton<String>(
                color: CustomColor.lightpurple.withOpacity(0.9),
                onSelected: (value) async {
                  if (value == 'edit') {
                    editFuntion();
                    //   log('onpressed pressed');
                    //   await CustomNavigation.push(
                    //       context,
                    //       AddCategoryScreen(
                    //         categoryId: category.id,
                    //         initialName: category.name,
                    //         initialImageUrl: category.imageUrl,
                    //       ));
                    //   log('after navigation  method start right now');
                    //   //  Navigator.of(context).pop();
                    //   //? this will call the  reload method again to fetch the data
                    //   // ignore: use_build_context_synchronously
                    //   context.read<CategoryBloc>().add(LoadCategories());
                    // } else if (value == 'delete') {
                    //   showModelDeleteCategory(context, category.id);
                  }
                  if (value == 'delete') {
                    deleteFunction();
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.white))
                        ],
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
