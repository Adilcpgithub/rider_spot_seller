import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/blocs/admin_order_bloc/admin_order_bloc.dart';
import 'package:ride_spot/features/orders/presentation/screens/updated_order/data/model/order_model.dart';
import 'package:intl/intl.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({super.key});

  @override
  State<AdminOrderPage> createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  // Define status options as constants to ensure consistency
  static const List<String> statusOptions = [
    'In Progress',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminOrderBloc>().add(FetchAllOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Orders",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF674fa3),
      ),
      body: BlocBuilder<AdminOrderBloc, AdminOrderState>(
        builder: (context, state) {
          if (state is AdminOrderLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF674fa3),
              ),
            );
          } else if (state is AdminOrderLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderCard(order);
              },
            );
          } else if (state is AdminOrderError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No orders found."));
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        child: Column(
          children: [
            // Header
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
                children: [
                  Expanded(
                    child: Text(
                      "Order #${order.orderId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusDropdown(order),
                ],
              ),
            ),
            // Order Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount:",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "₹${order.totalPrice}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF674fa3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Status: ${order.status}",
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF674fa3).withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.orderId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection(
                      'Order Information',
                      [
                        _buildInfoRow(
                            'Order Date',
                            DateFormat('MMM dd, yyyy hh:mm a')
                                .format(order.createdAt.toDate())),
                        _buildInfoRow('Total Amount', '₹${order.totalPrice}'),
                        _buildInfoRow('Status', order.status),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailSection(
                      'Delivery Address',
                      [
                        _buildInfoRow(
                            'House Name', order.address['houseName'] ?? ''),
                        _buildInfoRow(
                            'Post Office', order.address['postOffice'] ?? ''),
                        _buildInfoRow(
                            'District', order.address['district'] ?? ''),
                        _buildInfoRow('State', order.address['state'] ?? ''),
                        _buildInfoRow(
                            'PIN Code', order.address['pincode'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Order Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.items.length,
                      itemBuilder: (context, index) {
                        final item = order.items[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.brand,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '₹${item.price} x ${item.productCount}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '₹${item.price * item.productCount}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF674fa3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF674fa3), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: order.status,
          isDense: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF674fa3),
            size: 20,
          ),
          items: statusOptions.map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                status,
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newStatus) {
            if (newStatus != null && newStatus != order.status) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Update Order Status"),
                  content: Text(
                    "Are you sure you want to change the status to $newStatus?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<AdminOrderBloc>().add(
                              UpdateOrderStatus(
                                orderId: order.orderId,
                                newStatus: newStatus,
                              ),
                            );
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Color(0xFF674fa3)),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
