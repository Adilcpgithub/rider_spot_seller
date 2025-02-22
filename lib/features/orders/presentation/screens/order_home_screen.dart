import 'package:flutter/material.dart';
import 'package:ride_spot/features/orders/presentation/screens/order_screen.dart';
import 'package:ride_spot/utility/navigation.dart';

class OrderHomeScreen extends StatelessWidget {
  const OrderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OrderContainer(
              title: "All Orders",
              count: 50, // Example count
              icon: Icons.list_alt,
              color: Colors.orange,
              onTap: () {
                CustomNavigation.push(context, const OrderScreen());
              },
            ),
            const SizedBox(height: 16),
            OrderContainer(
              title: "Delivered Orders",
              count: 30,
              icon: Icons.check_circle,
              color: Colors.green,
              onTap: () {
                CustomNavigation.push(context, const OrderScreen());
              },
            ),
            const SizedBox(height: 16),
            OrderContainer(
              title: "Cancelled Orders",
              count: 5,
              icon: Icons.cancel,
              color: Colors.red,
              onTap: () {
                CustomNavigation.push(context, const OrderScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const OrderContainer(
      {super.key,
      required this.title,
      required this.count,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text("$count Orders",
                        style: TextStyle(color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
