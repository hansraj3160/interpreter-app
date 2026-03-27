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
      body: Obx(
        () {
          final hasId = controller.idDocumentPath.value.isNotEmpty;
          final hasCertification = controller.certificationPath.value.isNotEmpty;
          final canSubmit = hasId && hasCertification && !controller.isLoading.value;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Documents',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload a clear Government ID and your Professional Certification to activate your interpreter account.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _UploadCard(
                    title: 'Upload Government ID',
                    description: 'Passport, National ID, or Driver License',
                    filePath: controller.idDocumentPath.value,
                    onPick: controller.isLoading.value
                        ? null
                        : controller.pickIdDocument,
                  ),
                  const SizedBox(height: 14),
                  _UploadCard(
                    title: 'Upload Professional Certification',
                    description: 'Interpreter certificate or equivalent document',
                    filePath: controller.certificationPath.value,
                    onPick: controller.isLoading.value
                        ? null
                        : controller.pickCertificationDocument,
                  ),
                  const SizedBox(height: 16),
                  if (!hasId || !hasCertification)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Please select both documents before submitting.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canSubmit ? controller.uploadDocuments : null,
                      child: controller.isLoading.value
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
        },
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.description,
    required this.filePath,
    required this.onPick,
  });

  final String title;
  final String description;
  final String filePath;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFile = filePath.isNotEmpty;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.attach_file),
              label: Text(hasFile ? 'Change File' : 'Choose File'),
            ),
            const SizedBox(height: 12),
            if (hasFile)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      _iconForFile(filePath),
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _fileName(filePath),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                'No file selected',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static IconData _iconForFile(String path) {
    final fileName = _fileName(path).toLowerCase();
    if (fileName.endsWith('.pdf')) return Icons.picture_as_pdf_outlined;
    if (fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png')) {
      return Icons.image_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  static String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');
    return segments.isNotEmpty ? segments.last : path;
  }
}
