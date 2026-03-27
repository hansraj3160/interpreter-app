import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/interpreter_setup_controller.dart';

class ProfileSetupPage extends GetView<InterpreterSetupController> {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interpreter Profile Setup'),
      ),
      body: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your profile',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your language expertise, availability, and rates.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller.bioController,
                  minLines: 4,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: 'Bio *',
                    hintText: 'Tell clients about your interpreting experience',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.languageController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.addLanguage(),
                  decoration: InputDecoration(
                    labelText: 'Language *',
                    hintText: 'e.g. Arabic',
                    suffixIcon: IconButton(
                      onPressed: controller.addLanguage,
                      icon: const Icon(Icons.add),
                      tooltip: 'Add language',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (controller.selectedLanguages.isEmpty)
                  Text(
                    'No languages added yet.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.selectedLanguages
                        .map(
                          (lang) => Chip(
                            label: Text(lang),
                            onDeleted: () => controller.removeLanguage(lang),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.hourlyRateController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Hourly Rate (USD) *',
                    hintText: 'e.g. 45.00',
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Availability *',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: controller.selectedDay.value.isEmpty
                      ? null
                      : controller.selectedDay.value,
                  decoration: const InputDecoration(
                    labelText: 'Select Day',
                  ),
                  items: controller.daysOfWeek
                      .map(
                        (day) => DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedDay.value = value;
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.pickStartTime(context),
                        icon: const Icon(Icons.schedule),
                        label: Text(
                          controller.startTime.value.isEmpty
                              ? 'Start Time'
                              : controller.startTime.value,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.pickEndTime(context),
                        icon: const Icon(Icons.schedule),
                        label: Text(
                          controller.endTime.value.isEmpty
                              ? 'End Time'
                              : controller.endTime.value,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: controller.addAvailability,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Availability'),
                  ),
                ),
                const SizedBox(height: 12),
                if (controller.availabilityTimes.isEmpty)
                  Text(
                    'No availability slots added yet.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Column(
                    children: controller.availabilityTimes
                        .map(
                          (slot) => Card(
                            child: ListTile(
                              dense: true,
                              leading: const Icon(Icons.calendar_today_outlined),
                              title: Text('${slot.day}: ${slot.start} - ${slot.end}'),
                              trailing: IconButton(
                                onPressed: () =>
                                    controller.removeAvailability(slot),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updateProfile,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Update Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
