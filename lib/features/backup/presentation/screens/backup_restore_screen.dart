import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../providers/backup_provider.dart';

class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupAsync = ref.watch(backupProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(title: Text(loc['backup'])),
      body: backupAsync.when(
        data: (state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current backup info
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc['backup'],
                          style: AppTextStyles.headlineSmall,
                        ),
                        SizedBox(height: 8.h),
                        if (state.lastBackupDate != null) ...[
                          Text(
                            '${loc['last_backup']}: ${AppDateUtils.formatDisplay(state.lastBackupDate!)}',
                            style: AppTextStyles.bodyMedium,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${state.lastBackupPath ?? ''}',
                            style: AppTextStyles.caption,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else
                          Text(
                            loc['no_data'],
                            style: AppTextStyles.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Create Backup Button
                CustomButton(
                  label: loc['create_backup'],
                  icon: Icons.backup,
                  onPressed: state.isBackingUp
                      ? null
                      : () async {
                          try {
                            await ref.read(backupProvider.notifier).createBackup();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc['backup_created'])),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('${loc['error']}: $e')),
                              );
                            }
                          }
                        },
                ),
                SizedBox(height: 12.h),

                // Share Backup Button
                CustomButton(
                  label: loc['share_backup'],
                  icon: Icons.share,
                  backgroundColor: Colors.teal,
                  onPressed: state.lastBackupPath != null
                      ? () async {
                          try {
                            await FileUtils.shareFile(state.lastBackupPath!);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('${loc['error']}: $e')),
                              );
                            }
                          }
                        }
                      : null,
                ),
                SizedBox(height: 12.h),

                // Restore Backup Button
                CustomButton(
                  label: loc['restore_backup'],
                  icon: Icons.restore,
                  backgroundColor: Colors.orange,
                  onPressed: state.isRestoring
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['zip'],
                          );
                          if (result != null && result.files.isNotEmpty) {
                            final path = result.files.first.path!;
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(loc['restore_backup']),
                                content: Text(loc['confirm_restore']),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(loc['no']),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(loc['yes']),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              try {
                                await ref
                                    .read(backupProvider.notifier)
                                    .restoreBackup(path);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(loc['backup_restored'])),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('${loc['error']}: $e')),
                                  );
                                }
                              }
                            }
                          }
                        },
                ),
                SizedBox(height: 16.h),

                // Message display
                if (state.message != null)
                  Card(
                    color:
                        state.isError ? Colors.red.shade50 : Colors.green.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Icon(
                            state.isError ? Icons.error : Icons.check_circle,
                            color: state.isError ? Colors.red : Colors.green,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(child: Text(state.message!)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${loc['error']}: $err', style: AppTextStyles.bodyLarge),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => ref.invalidate(backupProvider),
                child: Text(loc['retry']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}