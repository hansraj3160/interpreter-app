import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_logo.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 36),

                // ── Logo ────────────────────────────────────────
                const AuthLogo(),
                const SizedBox(height: 24),

                Text(
                  'Join Us!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  controller.role == 'interpreter'
                      ? 'Sign up to offer your interpretation services.'
                      : 'Sign up to find professional interpreters.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ── Full Name ───────────────────────────────────
                TextFormField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),
                // ── Email ───────────────────────────────────────
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Please enter email';
                    final emailRegex = RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    );
                    if (!emailRegex.hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (!controller.isClientRole) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      TextFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (value) {
                          if (!controller.isClientRole) return null;
                          final phone = (value ?? '').replaceAll(
                            RegExp(r'\s+'),
                            '',
                          );
                          if (phone.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (phone.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.preferredLanguageController,
                        decoration: const InputDecoration(
                          labelText: 'Preferred Language',
                          hintText: 'Example: Hind, English',
                          prefixIcon: Icon(Icons.language_outlined),
                        ),
                        validator: (value) {
                          if (!controller.isClientRole) return null;
                          final languages = value
                                  ?.split(',')
                                  .map((e) => e.trim())
                                  .where((e) => e.isNotEmpty)
                                  .toList() ??
                              const [];
                          if (languages.isEmpty) {
                            return 'Please enter preferred language';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: controller.selectedGender.value.isEmpty
                            ? null
                            : controller.selectedGender.value,
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          prefixIcon: Icon(Icons.wc_outlined),
                        ),
                        items: controller.genderOptions
                            .map(
                              (gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          controller.selectedGender.value = value ?? '';
                        },
                        validator: (value) {
                          if (!controller.isClientRole) return null;
                          if (value == null || value.isEmpty) {
                            return 'Please select gender';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.dateOfBirthController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'YYYY-MM-DD',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        onTap: () => controller.pickDateOfBirth(context),
                        validator: (value) {
                          if (!controller.isClientRole) return null;
                          if (value == null || value.trim().isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

              

                // ── Password ────────────────────────────────────
                Obx(() => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    )),
                const SizedBox(height: 16),

                // ── Confirm Password ───────────────────────────
                Obx(() => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        final confirm = value?.trim() ?? '';
                        if (confirm.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (confirm != controller.passwordController.text.trim()) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 32),

                // ── Sign Up Button ──────────────────────────────
                Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                      ? null
                      : () {
                        final isValid =
                          _formKey.currentState?.validate() ?? false;
                        if (!isValid) return;
                        controller.signup();
                      },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign Up'),
                    )),

                const SizedBox(height: 24),

                // ── Back to Login ───────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}