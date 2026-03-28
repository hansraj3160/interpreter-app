import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/interpreter_upload_docs_controller.dart';

class UploadDocsPage extends GetView<InterpreterUploadDocsController> {
  const UploadDocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: Obx(() {
        final identityProof = controller.identityProof.value;
        final languageCertificates = controller.languageCertificates;
        final resume = controller.resume.value;
        final isLoading = controller.isLoading.value;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Documents',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your professional documents. Formats: PDF, JPG, PNG.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                _buildUploadCard(
                  context: context,
                  title: 'Identity Proof',
                  onTap: isLoading ? () {} : controller.pickIdentityProof,
                  content: identityProof == null
                      ? _buildEmptyState(
                          context,
                          label: 'Tap to upload identity proof',
                        )
                      : _buildFileTile(
                          context,
                          fileName: identityProof.name,
                          onDelete: isLoading ? null : controller.removeIdentityProof,
                        ),
                ),
                const SizedBox(height: 14),
                _buildUploadCard(
                  context: context,
                  title: 'Language Certificates',
                  onTap: isLoading ? () {} : controller.pickLanguageCertificates,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : controller.pickLanguageCertificates,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Certificate'),
                      ),
                      const SizedBox(height: 10),
                      if (languageCertificates.isEmpty)
                        _buildEmptyState(
                          context,
                          label: 'No certificates added yet',
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(languageCertificates.length, (index) {
                            final file = languageCertificates[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colorScheme.outlineVariant),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 170),
                                    child: Text(
                                      file.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: isLoading
                                        ? null
                                        : () => controller.removeLanguageCertificate(index),
                                    icon: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _buildUploadCard(
                  context: context,
                  title: 'Resume',
                  onTap: isLoading ? () {} : controller.pickResume,
                  content: resume == null
                      ? _buildEmptyState(
                          context,
                          label: 'Tap to upload resume',
                        )
                      : _buildFileTile(
                          context,
                          fileName: resume.name,
                          onDelete: isLoading ? null : controller.removeResume,
                        ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : controller.uploadDocuments,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Text('Submit Documents'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUploadCard({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upload_file_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, {required String label}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileTile(
    BuildContext context, {
    required String fileName,
    required VoidCallback? onDelete,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            color: colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
