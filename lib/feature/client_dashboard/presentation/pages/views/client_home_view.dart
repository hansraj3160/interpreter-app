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
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  _buildWalletCard(context),
                  _buildSearchBar(context),
                  _buildCategories(context),
                  _buildInterpreterList(context),
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
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.onSurfaceVariant,
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
          CircleAvatar(
            radius: 22,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.person_outline,
              color: colorScheme.onPrimaryContainer,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r'$50.00',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.primary,
              ),
              child: const Text('Add Funds / Top-up'),
            ),
          ],
        ),
      ),
    );
  }

  /// SEARCH BAR
  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: TextField(
          onChanged: (val) => controller.searchQuery.value = val,
          decoration: InputDecoration(
            hintText: 'Search interpreters...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            suffixIcon: Icon(
              Icons.tune,
              color: colorScheme.primary,
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
    final allLanguages = ['All', ...controller.languages];

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
            child: Obx(() {
              final selectedLang = controller.selectedLanguage.value;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allLanguages.length,
                itemBuilder: (context, index) {
                  final language = allLanguages[index];
                  final isSelected = language == 'All'
                      ? selectedLang.isEmpty
                      : selectedLang == language;

                  return LanguageFilterChip(
                    label: language,
                    isSelected: isSelected,
                    onTap: () {
                      controller.selectedLanguage.value =
                          language == 'All' ? '' : language;
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpreterList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                child: const Text('See All'),
              )
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            // Eagerly read all observables so GetX tracks them as dependencies.
            final isLoading = controller.isLoadingInterpreters.value;
            final error = controller.errorMessage.value;
            final query = controller.searchQuery.value.trim().toLowerCase();
            final selectedLang = controller.selectedLanguage.value.trim().toLowerCase();
            final allInterpreters = controller.interpretersList;

            // 1. Loading with empty list → full-screen spinner
            if (isLoading && allInterpreters.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            // 2. Error state (only shown when list is also empty)
            if (error != null && error.isNotEmpty && allInterpreters.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => controller.fetchInterpreters(isRefresh: true),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // 3. Client-side filter over the fetched list
            final interpreters = allInterpreters.where((interpreter) {
              final matchesLang = selectedLang.isEmpty ||
                  interpreter.language.toLowerCase().contains(selectedLang);
              final matchesQuery = query.isEmpty ||
                  interpreter.name.toLowerCase().contains(query) ||
                  interpreter.language.toLowerCase().contains(query) ||
                  interpreter.specialty.toLowerCase().contains(query);
              return matchesLang && matchesQuery;
            }).toList();

            // 4. Empty result
            if (interpreters.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No interpreters available.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            // 5. List
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: interpreters.length,
              itemBuilder: (context, index) {
                return InterpreterCard(interpreter: interpreters[index]);
              },
            );
          }),
        ],
      ),
    );
  }
}