import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:ride_spot/features/orders/presentation/screens/order_screen.dart';
import 'package:ride_spot/pages/home_page.dart';
import 'package:ride_spot/pages/products_page.dart';
import 'package:ride_spot/pages/settings_page.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class BottomNavigationPage extends StatefulWidget {
  final int pageIndex;
  const BottomNavigationPage({super.key, this.pageIndex = 0});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigationPage> {
  late int _selectedIndex;
  @override
  void initState() {
    _selectedIndex = widget.pageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> pages = const [
      HomePage(),
      OrderScreen(),
      ProductPage(),
      SettingsPage()
    ];
    List<Color> color = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 500),
        color: const Color.fromARGB(255, 223, 223, 223),
        onTap: (value) => onItemTapped(value),
        backgroundColor: color[_selectedIndex],
        items: [
          CurvedNavigationBarItem(
              child: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? Colors.white
                    : CustomColor.lightpurple,
              ),
              label: 'Home',
              labelStyle: TextStyle(color: CustomColor.lightpurple)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.local_shipping_outlined,
                color: _selectedIndex == 1
                    ? Colors.white
                    : CustomColor.lightpurple,
              ),
              label: 'Orders',
              labelStyle: TextStyle(color: CustomColor.lightpurple)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.add_shopping_cart_outlined,
                color: _selectedIndex == 2
                    ? Colors.white
                    : CustomColor.lightpurple,
              ),
              label: 'Store',
              labelStyle: TextStyle(color: CustomColor.lightpurple)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                color: _selectedIndex == 3
                    ? Colors.white
                    : CustomColor.lightpurple,
              ),
              label: 'Settings',
              labelStyle: TextStyle(color: CustomColor.lightpurple))
        ],
        buttonBackgroundColor: CustomColor.lightpurple,
      ),
    );
  }
}

void showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Product'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle delete logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
