import 'package:get/get.dart';

class ClientDashboardController extends GetxController {
  // Bottom Navigation state
  final RxInt currentIndex = 0.obs;

  // Search input state
  final RxString searchQuery = ''.obs;

  // Dummy list of languages for quick filters
  final List<String> languages = ['Spanish', 'ASL (Sign)', 'French', 'Mandarin', 'Arabic', 'German'];

  // Dummy list of Top Interpreters
  final List<Map<String, dynamic>> topInterpreters = [
    {
      'name': 'Sarah Johnson',
      'language': 'Spanish, English',
      'rating': 4.9,
      'reviews': 124,
      'rate': '\$35/hr',
      'specialty': 'Medical & Legal'
    },
    {
      'name': 'David Chen',
      'language': 'Mandarin, English',
      'rating': 4.8,
      'reviews': 89,
      'rate': '\$40/hr',
      'specialty': 'Business'
    },
    {
      'name': 'Maria Garcia',
      'language': 'ASL, English',
      'rating': 5.0,
      'reviews': 210,
      'rate': '\$45/hr',
      'specialty': 'General'
    },
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}