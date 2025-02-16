import 'package:flutter/material.dart';
import 'package:ride_spot/utility/app_logo.dart';

class DashboardPageWidgets {
  static dashInfoContainer(
      {required Color containerColor,
      required String infoName,
      required int infoCount,
      Color? textColor}) {
    return Container(
      width: 180,
      height: 130,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            infoName,
            style: TextStyle(
                fontSize: 20,
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            infoCount.toString(),
            style: TextStyle(
                fontSize: 20,
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

//! topProuctContainer
  static topProductList() {
    const List<Map<String, dynamic>> products = [
      {
        "name": "Nike Shoes",
        "price": "\$120",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Apple Watch",
        "price": "\$250",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Apple Watch",
        "price": "\$250",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Apple Watch",
        "price": "\$250",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Apple Watch",
        "price": "\$250",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Headphones",
        "price": "\$90",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Backpack",
        "price": "\$45",
        "image": "https://via.placeholder.com/50",
      },
      {
        "name": "Smartphone",
        "price": "\$999",
        "image": "https://via.placeholder.com/50",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Top Sales',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 430,
          decoration: BoxDecoration(
            color: const Color.fromARGB(195, 103, 79, 163),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 420, // Ensure ListView has a defined height
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                            width: 50, // Set a fixed width
                            height: 50,
                            child: Image.asset(appLogo(), fit: BoxFit.cover)),
                      ),
                      title: Text(
                        product["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        product["price"],
                        style:
                            const TextStyle(color: Colors.green, fontSize: 10),
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.shopping_cart, color: Colors.blue),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text("${product["name"]} added to cart!")),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
