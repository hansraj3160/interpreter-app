import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/client_profile_controller.dart';
import '../widgets/profile_list_tile.dart';

class ClientProfileView extends GetView<ClientProfileController> {
  const ClientProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: controller.fetchUserProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = controller.userData.value;
        if (user == null) {
          return Center(
            child: Text(
              'No profile data available.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        final avatarUrl = user.profileImage.isNotEmpty
            ? user.profileImage
            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name.isEmpty ? 'Client' : user.name)}';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: NetworkImage(avatarUrl),
                        onBackgroundImageError: (_, __) {},
                        child: user.profileImage.isEmpty
                            ? Icon(
                                Icons.person_outline,
                                size: 36,
                                color: colorScheme.onPrimaryContainer,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name.isEmpty ? 'Client' : user.name,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Account Settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ProfileListTile(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.history_outlined,
                      title: 'Booking History',
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: controller.logout,
                icon: Icon(
                  Icons.logout,
                  color: colorScheme.error,
                ),
                label: Text(
                  'Logout',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}