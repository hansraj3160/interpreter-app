import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interpreter_app/feature/welcome/presentation/controller/welcome_controller.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Choose Account Type',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'How would you like to use the application?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Client Selection Card
              Obx(() => _buildRoleCard(
                    context: context,
                    title: 'Client',
                    description: 'I want to search and book professional interpreters.',
                    icon: Icons.person_search_rounded,
                    value: 'client',
                    groupValue: controller.selectedRole.value,
                    onTap: () => controller.selectRole('client'),
                  )),
                  
              const SizedBox(height: 20),
              
              // Interpreter Selection Card
              Obx(() => _buildRoleCard(
                    context: context,
                    title: 'Interpreter',
                    description: 'I want to provide interpretation services and manage bookings.',
                    icon: Icons.record_voice_over_rounded,
                    value: 'interpreter',
                    groupValue: controller.selectedRole.value,
                    onTap: () => controller.selectRole('interpreter'),
                  )),
                  
              const Spacer(),
              
              // Continue Button
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.continueToNext,
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Reusable Widget for Role Cards
  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required String value,
    required String groupValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == groupValue;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Radio button style indicator
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}