import 'package:flutter/material.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.grey[300],
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            //   return const AddProductPage();
            // }));
          },
          child: Icon(
            Icons.add,
            color: CustomColor.lightpurple,
          ),
        ),
      ),
    );
  }
}
