import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/client_dashboard_controller.dart';
import '../widgets/interpreter_card.dart';
import '../widgets/language_filter_chip.dart';

class ClientHomeView extends StatelessWidget {
  final ClientDashboardController controller;

  const ClientHomeView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildSearchBar(context),
                  _buildCategories(context),
                  _buildTopInterpreters(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// HEADER
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Client 👋',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Find Your Interpreter',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/?name=Client&background=EBF4FF&color=1E88E5',
            ),
          )
        ],
      ),
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          onChanged: (val) => controller.searchQuery.value = val,
          decoration: InputDecoration(
            hintText: "Search interpreters...",
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            icon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
            suffixIcon: Icon(
              Icons.tune,
              color: theme.colorScheme.primary,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// LANGUAGE CHIPS
  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Popular Languages",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.languages.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  final language = controller.languages[index];
                  final isSelected =
                      controller.selectedLanguage.value == language;

                  return LanguageFilterChip(
                    label: language,
                    isSelected: isSelected,
                    onTap: () => controller.selectedLanguage.value = language,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// INTERPRETERS
  Widget _buildTopInterpreters(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Top Rated Interpreters",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("See All"),
              )
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingInterpreters.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.interpretersError.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      controller.interpretersError.value,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.fetchInterpreters,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (controller.topInterpreters.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No interpreters available right now.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topInterpreters.length,
              itemBuilder: (context, index) {
                final interpreter = controller.topInterpreters[index];

                return InterpreterCard(
                  interpreter: interpreter,
                );
              },
            );
          }),
        ],
      ),
    );
  }
}