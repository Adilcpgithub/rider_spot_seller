import 'package:flutter/material.dart';
import 'package:ride_spot/pages/add_product.dart';
import 'package:ride_spot/utility/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.grey[300],
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return AddProductPage();
            }));
          },
          child: const Icon(
            Icons.add,
            color: CustomColor.primaryColor,
          ),
        ),
      ),
    );
  }
}
