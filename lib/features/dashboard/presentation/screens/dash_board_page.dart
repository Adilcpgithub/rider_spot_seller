import 'package:flutter/material.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/dash_page_widgets.dart';
import 'package:ride_spot/features/dashboard/presentation/widget/graph.dart';
import 'package:ride_spot/theme/custom_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  DashboardPageWidgets.dashInfoContainer(
                      containerColor: Colors.purple[100]!,
                      infoName: 'Orders',
                      infoCount: 27),
                  const Expanded(child: SizedBox()),
                  DashboardPageWidgets.dashInfoContainer(
                      containerColor: const Color.fromARGB(39, 255, 17, 0),
                      infoName: 'Pending',
                      infoCount: 16),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: LineChartSample2(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  DashboardPageWidgets.dashInfoContainer(
                      containerColor: CustomColor.lightpurple,
                      infoName: 'Revenue',
                      infoCount: 200,
                      textColor: Colors.white),
                  const Expanded(child: SizedBox()),
                  DashboardPageWidgets.dashInfoContainer(
                      containerColor: CustomColor.lightpurple,
                      infoName: 'Customer',
                      infoCount: 189,
                      textColor: Colors.white),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              DashboardPageWidgets.topProductList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
