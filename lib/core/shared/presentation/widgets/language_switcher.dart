import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/shared/services/language_service.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';

/// Widget for switching between supported languages with bottom sheet
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final currentLanguage = LanguageService.getLanguageByLocale(
          state.locale,
        );

        return IconButton(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language),
              if (currentLanguage?.icon != null) ...[
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    currentLanguage!.icon!,
                    key: ValueKey(currentLanguage.identifier),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ],
          ),
          onPressed: () => _showLanguageBottomSheet(context, state.locale),
          tooltip:
              'Select Language', // Will use localized string after flutter pub get
        );
      },
    );
  }

  /// Show the language selection bottom sheet
  void _showLanguageBottomSheet(BuildContext context, Locale currentLocale) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return LanguageBottomSheet(currentLocale: currentLocale);
      },
    );
  }
}

/// Bottom sheet widget for language selection
class LanguageBottomSheet extends StatelessWidget {
  final Locale currentLocale;

  const LanguageBottomSheet({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Language',
                  // Will use localized string after flutter pub get
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(),

          // Language list
          ...LanguageService.supportedLanguages.map((language) {
            final isSelected =
                language.locale.languageCode == currentLocale.languageCode &&
                language.locale.countryCode == currentLocale.countryCode &&
                language.locale.scriptCode == currentLocale.scriptCode;

            return Material(
              color: Colors.transparent,
              child: ListTile(
                title: Text(
                  language.nativeName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Theme.of(context).primaryColor : null,
                  ),
                ),
                subtitle: language.displayName != language.nativeName
                    ? Text(
                        language.displayName,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.7)
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      )
                    : null,
                trailing: AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                selected: isSelected,
                selectedTileColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.05),
                onTap: () {
                  if (!isSelected) {
                    // Change language
                    context.read<AppCubit>().changeLocale(language.locale);

                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Language changed to ${language.nativeName}',
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }

                  // Close bottom sheet
                  Navigator.pop(context);
                },
              ),
            );
          }),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
