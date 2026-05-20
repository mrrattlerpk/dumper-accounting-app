import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/routes/app_router.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final loc = context.loc;

    return Scaffold(
      appBar: AppBar(title: Text(loc['settings'])),
      body: settingsAsync.when(
        data: (settings) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language section
                _SectionTitle(title: loc['language']),
                Card(
                  child: ListTile(
                    title: Text(loc['language']),
                    subtitle: Text(
                      settings.languageCode == 'ur' ? 'اردو' : 'English',
                    ),
                    trailing: Switch(
                      value: settings.languageCode == 'ur',
                      onChanged: (isUrdu) async {
                        final newLang = isUrdu ? 'ur' : 'en';
                        await ref
                            .read(settingsProvider.notifier)
                            .updateLanguage(newLang);
                        ref.read(localeProvider.notifier).state =
                            Locale(newLang);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // PDF Settings
                _SectionTitle(title: loc['pdf_export']),
                Card(
                  child: ListTile(
                    title: Text(loc['pdf_page_size']),
                    subtitle: Text(settings.pdfPageSize),
                    trailing: DropdownButton<String>(
                      value: settings.pdfPageSize,
                      underline: const SizedBox(),
                      items: AppConstants.pageSizes
                          .map((size) => DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .updatePdfPageSize(value);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Backup Settings
                _SectionTitle(title: loc['backup']),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(loc['auto_backup']),
                        subtitle: Text(
                          settings.autoBackupIntervalHours > 0
                              ? '${loc['backup_interval']}: ${settings.autoBackupIntervalHours}h'
                              : loc['disabled'],
                        ),
                        trailing: Switch(
                          value: settings.autoBackupIntervalHours > 0,
                          onChanged: (on) {
                            ref.read(settingsProvider.notifier).updateAutoBackupInterval(
                                  on ? AppConstants.defaultAutoBackupIntervalHours : 0,
                                );
                          },
                        ),
                      ),
                      if (settings.autoBackupIntervalHours > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Slider(
                            value: settings.autoBackupIntervalHours.toDouble(),
                            min: 1,
                            max: 72,
                            divisions: 71,
                            label: '${settings.autoBackupIntervalHours}h',
                            onChanged: (val) {
                              ref.read(settingsProvider.notifier).updateAutoBackupInterval(
                                    val.round(),
                                  );
                            },
                          ),
                        ),
                      ListTile(
                        title: Text(loc['create_backup']),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.backupRestore);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Business Details
                _SectionTitle(title: loc['business_details']),
                Card(
                  child: Column(
                    children: [
                      _EditableTile(
                        label: loc['business_name'],
                        value: settings.businessName ?? '',
                        onChanged: (val) {
                          final updated = settings.copyWith(
                            businessName: val,
                            updatedAt: DateTime.now(),
                          );
                          ref.read(settingsProvider.notifier).updateSettings(updated);
                        },
                      ),
                      _EditableTile(
                        label: loc['business_phone'],
                        value: settings.businessPhone ?? '',
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          final updated = settings.copyWith(
                            businessPhone: val,
                            updatedAt: DateTime.now(),
                          );
                          ref.read(settingsProvider.notifier).updateSettings(updated);
                        },
                      ),
                      _EditableTile(
                        label: loc['business_address'],
                        value: settings.businessAddress ?? '',
                        maxLines: 2,
                        onChanged: (val) {
                          final updated = settings.copyWith(
                            businessAddress: val,
                            updatedAt: DateTime.now(),
                          );
                          ref.read(settingsProvider.notifier).updateSettings(updated);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80.h), // space for bottom nav
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (err, _) => Center(
          child: Text('${loc['error']}: $err', style: AppTextStyles.bodyLarge),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall,
      ),
    );
  }
}

class _EditableTile extends StatefulWidget {
  final String label;
  final String value;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String> onChanged;

  const _EditableTile({
    required this.label,
    required this.value,
    this.keyboardType,
    this.maxLines,
    required this.onChanged,
  });

  @override
  State<_EditableTile> createState() => _EditableTileState();
}

class _EditableTileState extends State<_EditableTile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _EditableTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      subtitle: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines ?? 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}