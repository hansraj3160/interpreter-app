import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interpreter_app/routes/app_pages.dart';

class AuthController extends GetxController {
  // Role aayega Welcome screen se
  String role = '';

  // Form Keys for validation
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // Text Controllers
  final emailController = TextEditingController(text: "abc@gmail.com");
  final passwordController = TextEditingController(text: "password123");
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
      await Future.delayed(const Duration(seconds: 2)); // Simulating API
      isLoading.value = false;
      
      Get.snackbar('Success', 'Logged in successfully!', snackPosition: SnackPosition.BOTTOM);
      
      // Role ke hisaab se dashboard par navigate karein
      if (role == 'client') {
      Get.offAllNamed(Routes.CLIENT_DASHBOARD);
      } else {
        // Future mein interpreter dashboard yahan aayega
        // Get.offAllNamed('/interpreter-dashboard'); 
      }
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