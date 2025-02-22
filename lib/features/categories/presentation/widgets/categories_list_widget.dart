import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/categories/data/models/category_model.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/features/categories/presentation/screens/add_edit_category_screen.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/small_text_button.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/app_logo.dart';
import 'package:ride_spot/utility/navigation.dart';

class CategoriesListWidget {
  //! showing image and category name in full size
  static showProfileDialog(
      {required BuildContext context,
      required String imageUrl,
      required bool isDefaulImage,
      required String categoryName}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 390,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      categoryName,
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: isDefaulImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                imageUrl,
                                fit: BoxFit.fill,
                                height: 250,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person_rounded,
                                      size: 130, color: Colors.black45);
                                },
                                width: 300,
                                height: 300,
                              ),
                            ),
                    ),
                  ]),
            ),
          );
        });
  }

  //! category container
  static Widget buildCategoryContainer(
      BuildContext context, CategoryModel category) {
    return Card(
        elevation: 7,
        //color: Colors.purple[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 8), // Add spacing between items
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 0.5, color: CustomColor.lightpurple.withOpacity(0.9)),
            color: Colors.white,
          ),
          height: 120,
          width: double.maxFinite,
          child: Row(
            children: [
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  CategoriesListWidget.showProfileDialog(
                      context: context,
                      imageUrl: category.imageUrl,
                      isDefaulImage: !category.isEditable,
                      categoryName: category.name);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: AssetImage(appLogo()))),
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: category.isEditable
                        ? Image.network(
                            category.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(appLogo()));
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return const SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            category.imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.scaleDown,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              //?Category Name
              Expanded(
                child: GestureDetector(
                  onTap: () => CategoriesListWidget.showProfileDialog(
                      context: context,
                      imageUrl: category.imageUrl,
                      isDefaulImage: !category.isEditable,
                      categoryName: category.name),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),

              category.isEditable
                  ? PopupMenuButton<String>(
                      color: CustomColor.lightpurple.withOpacity(0.9),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          log('onpressed pressed');
                          await CustomNavigation.push(
                              context,
                              AddCategoryScreen(
                                categoryId: category.id,
                                initialName: category.name,
                                initialImageUrl: category.imageUrl,
                              ));
                          log('after navigation  method start right now');
                          //  Navigator.of(context).pop();
                          //? this will call the  reload method again to fetch the data
                          // ignore: use_build_context_synchronously
                          context.read<CategoryBloc>().add(LoadCategories());
                        } else if (value == 'delete') {
                          showModelDeleteCategory(context, category.id);
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
                                Text('Delete',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ))
                      ],
                    )
                  : const SizedBox.shrink(),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 23,
                ),
                onPressed: () {
                  // Handle action
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ));
  }

  //! Show dialog for Delete category
  static showModelDeleteCategory(
      BuildContext context, String categoryId) async {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
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
                    'Delete Category',
                    style: TextStyle(
                      decorationThickness: 0,
                      color: Colors.black,
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
                            width: 1.5,
                            textColor: Colors.black,
                            buttomName: 'Cancel',
                            fontweight: 16,
                            voidCallBack: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: SmallTextbutton(
                            width: 1.5,
                            textColor: Colors.black,
                            buttomName: 'Ok',
                            fontweight: 16,
                            voidCallBack: () async {
                              context
                                  .read<CategoryBloc>()
                                  .add(DeleteCategory(categoryId));
                              Navigator.pop(context);
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
        });
  }
}
