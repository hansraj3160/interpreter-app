import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/client_dashboard_controller.dart';
import 'views/client_home_view.dart';
import 'views/client_bookings_view.dart';
import 'views/client_messages_view.dart';
import 'views/client_profile_view.dart';

class ClientDashboardPage extends GetView<ClientDashboardController> {
  const ClientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // SafeArea ko yahan se hatakar individual views mein lagayenge
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          ClientHomeView(controller: controller), // Purana Home UI
          const ClientBookingsView(),
          const ClientMessagesView(),
          const ClientProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTabIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      )),
    );
  }
}