import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:ride_spot/pages/test_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        color: Colors.green,
        onTap: (value) => _onItemTapped(value),
        backgroundColor: color[_selectedIndex],
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.local_shipping),
            label: 'Orders',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart_sharp),
            label: 'Store',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
        buttonBackgroundColor: Colors.amber,
      ),
    );
  }

  List<Widget> pages = [Test(), Test(), Test(), ss()];
  List<Color> color = [Colors.white, Colors.white, Colors.white, Colors.blue];
}

class ss extends StatelessWidget {
  const ss({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text('addfasdf'),
      ),
    );
  }
}
