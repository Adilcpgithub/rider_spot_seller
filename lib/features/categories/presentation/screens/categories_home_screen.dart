import 'package:flutter/material.dart';
import 'package:ride_spot/features/categories/presentation/screens/add_edit_category_screen.dart';
import 'package:ride_spot/features/categories/presentation/screens/categories_list_screen.dart';
import 'package:ride_spot/features/categories/presentation/widgets/categories_home_widgets.dart';
import 'package:ride_spot/theme/custom_colors.dart';
import 'package:ride_spot/utility/navigation.dart';

class CategoriesHomeScreen extends StatelessWidget {
  const CategoriesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CategorieContainer(
              title: "Manage Categories",
              icon: Icons.dashboard_customize,
              color: CustomColor.lightpurple,
              onTap: () {
                //
                CustomNavigation.push(context, const CategoriesListScreen());
              },
            ),
            const SizedBox(height: 16),
            CategorieContainer(
              title: "Add New Category",
              icon: Icons.library_add,
              color: Colors.green,
              onTap: () {
                CustomNavigation.push(context, const AddCategoryScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
