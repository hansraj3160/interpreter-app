import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Role aayega Welcome screen se
  String role = '';

  // Form Keys for validation
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // For Signup

  // Observables for state management
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Welcome screen se bheja gaya argument capture karein
    if (Get.arguments != null && Get.arguments['role'] != null) {
      role = Get.arguments['role'];
    } else {
      role = 'client'; // fallback
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      // TODO: API Call yahan aayegi Dio ke through
      await Future.delayed(const Duration(seconds: 2)); // Simulating network req
      isLoading.value = false;
      
      Get.snackbar('Success', 'Logged in successfully as ${role.capitalizeFirst}', snackPosition: SnackPosition.BOTTOM);
      // Get.offAllNamed(Routes.HOME); // Aage chal kar Home par bhejenge
    }
  }

  void signup() async {
    if (signupFormKey.currentState!.validate()) {
      isLoading.value = true;
      // TODO: API Call yahan aayegi
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      Get.snackbar('Success', 'Account created successfully!', snackPosition: SnackPosition.BOTTOM);
      Get.offNamed('/login', arguments: {'role': role});
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}