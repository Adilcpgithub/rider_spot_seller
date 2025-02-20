import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.lightpurple,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sampleOrders.length,
          itemBuilder: (context, index) {
            final order = sampleOrders[index];
            return OrderCard(order: order);
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late OrderStatus currentStatus;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.order.status;
  }

  void _updateOrderStatus(OrderStatus? newStatus) {
    if (newStatus != null) {
      setState(() {
        currentStatus = newStatus;
      });
      // Here you would typically make an API call to update the status
      _showUpdateSuccessSnackbar();
    }
  }

  void _showUpdateSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order status updated to ${currentStatus.name}'),
        backgroundColor: const Color(0xFF674fa3),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF674fa3).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Id #${widget.order.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusDropdown(),
                //
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          ///!!!
          _isExpanded ? dddd() : const SizedBox.shrink()
        ],
      ),
    );
  }

  dddd() {
    return Column(
      children: [
        ListTile(
          title: const Text("Order Details",
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.blue,
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle expansion
            });
          },
        ),
        !_isExpanded
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.order.items.length,
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${item.quantity}x ₹${item.price}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Text(
                      '₹${item.quantity * item.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Date',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(widget.order.orderDate),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '₹${widget.order.totalAmount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF674fa3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to order details
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF674fa3),
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(currentStatus).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<OrderStatus>(
        value: currentStatus,
        items: OrderStatus.values.map((OrderStatus status) {
          return DropdownMenuItem<OrderStatus>(
            value: status,
            child: Text(
              status.name.toUpperCase(),
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        }).toList(),
        onChanged: _updateOrderStatus,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: _getStatusColor(currentStatus),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.shipped:
        return Colors.blue;
    }
  }
}

// Models
enum OrderStatus {
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered'),
  cancelled('Cancelled');

  final String displayName;
  const OrderStatus(this.displayName);
}

class Order {
  final String orderId;
  final List<OrderItem> items;
  final DateTime orderDate;
  final double totalAmount;
  final OrderStatus status;

  Order({
    required this.orderId,
    required this.items,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });
}

// Sample Data
final List<Order> sampleOrders = [
  Order(
    orderId: '12345',
    items: [
      OrderItem(
        name: 'Wireless Earbuds',
        imageUrl: 'https://example.com/earbuds.jpg',
        quantity: 1,
        price: 2999,
      ),
      OrderItem(
        name: 'Phone Case',
        imageUrl: 'https://example.com/case.jpg',
        quantity: 2,
        price: 499,
      ),
    ],
    orderDate: DateTime.now().subtract(const Duration(days: 2)),
    totalAmount: 3997,
    status: OrderStatus.processing,
  ),
  Order(
    orderId: '12344',
    items: [
      OrderItem(
        name: 'Smart Watch',
        imageUrl: 'https://example.com/watch.jpg',
        quantity: 1,
        price: 5999,
      ),
    ],
    orderDate: DateTime.now().subtract(const Duration(days: 5)),
    totalAmount: 5999,
    status: OrderStatus.delivered,
  ),
];
