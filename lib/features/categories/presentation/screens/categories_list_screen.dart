import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/categories/presentation/blocs/add_category/category_bloc.dart';
import 'package:ride_spot/features/categories/presentation/widgets/categories_list_widget.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  @override
  void initState() {
    context.read<CategoryBloc>().add(LoadCategories());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "All Categories",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryAddedFailure) {
            return Center(child: Text(state.error));
          } else if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text("No categories found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoriesListWidget.buildCategoryContainer(
                    context, category);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
