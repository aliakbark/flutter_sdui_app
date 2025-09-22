import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/core/shared/states/app/app_cubit.dart';
import 'package:flutter_sdui_app/l10n/app_localizations.dart';

/// Widget that wraps content with a network status banner
class NetworkBannerWrapper extends StatelessWidget {
  final Widget child;

  const NetworkBannerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final bool showBanner = !state.isNetworkConnected;

        return SafeArea(
          top: showBanner,
          bottom: false,
          left: false,
          right: false,
          child: Column(
            children: [
              RepaintBoundary(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: showBanner ? null : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: showBanner ? 1.0 : 0.0,
                    child: Semantics(
                      liveRegion: true,
                      label: showBanner ? 'No internet connection available' : '',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Semantics(
                              label: 'No internet connection icon',
                              child: const Icon(
                                Icons.wifi_off,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Semantics(
                              label: 'Network status message',
                              child: Text(
                                AppLocalizations.of(context)!.noInternetConnection,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Main app content - isolated from banner repainting
              Expanded(child: RepaintBoundary(child: child)),
            ],
          ),
        );
      },
    );
  }
}
