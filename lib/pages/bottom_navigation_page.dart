import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ride_spot/pages/home_page.dart';
import 'package:ride_spot/pages/settings_page.dart';
import 'package:ride_spot/pages/add_product.dart';
import 'package:ride_spot/pages/store_page.dart';
import 'package:ride_spot/utility/colors.dart';

class BottomNavigationPage extends StatefulWidget {
  final int pageIndex;
  BottomNavigationPage({super.key, this.pageIndex = 0});

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
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        // key: Key(_selectedIndex.toString()),
        animationDuration: const Duration(milliseconds: 500),
        color: Color.fromARGB(255, 223, 223, 223),
        onTap: (value) => _onItemTapped(value),
        backgroundColor: color[_selectedIndex],
        items: [
          CurvedNavigationBarItem(
              child: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0
                    ? Colors.white
                    : CustomColor.primaryColor,
              ),
              label: 'Home',
              labelStyle: const TextStyle(color: CustomColor.primaryColor)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.local_shipping_outlined,
                color: _selectedIndex == 1
                    ? Colors.white
                    : CustomColor.primaryColor,
              ),
              label: 'Orders',
              labelStyle: const TextStyle(color: CustomColor.primaryColor)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.add_shopping_cart_outlined,
                color: _selectedIndex == 2
                    ? Colors.white
                    : CustomColor.primaryColor,
              ),
              label: 'Store',
              labelStyle: TextStyle(color: CustomColor.primaryColor)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                color: _selectedIndex == 3
                    ? Colors.white
                    : CustomColor.primaryColor,
              ),
              label: 'Settings',
              labelStyle: const TextStyle(color: CustomColor.primaryColor))
        ],
        buttonBackgroundColor: CustomColor.primaryColor,
      ),
    );
  }

  List<Widget> pages = [
    HomePage(),
    SettingsPage(),
    StorePage(),
    SettingsPage()
  ];
  List<Color> color = [Colors.white, Colors.white, Colors.white, Colors.white];
}

void _showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
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

void _showDeleteConfirmation(BuildContext context) {
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
