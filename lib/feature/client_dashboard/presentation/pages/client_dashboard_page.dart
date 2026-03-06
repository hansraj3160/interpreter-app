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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: [
                ClientHomeView(controller: controller),
                const ClientBookingsView(),
                const ClientMessagesView(),
                const ClientProfileView(),
              ],
            )),
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Obx(() => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTabIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month), label: 'Bookings'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            )),
      ),
    );
  }
}