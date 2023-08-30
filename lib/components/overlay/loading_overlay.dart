import 'package:flutter/material.dart';
import 'package:todo_list/components/overlay/overlay_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingOverlay {
  OverlayController? _controller;

  bool get isShown => _controller != null;

  LoadingOverlay._();
  static final _instance = LoadingOverlay._();
  factory LoadingOverlay.instance() => _instance;

  void show(BuildContext context) {
    if (!isShown) {
      final overlay = Overlay.of(context);
      final loadingOverlay = _loadingOverlay();
      overlay.insert(loadingOverlay);

      _controller = OverlayController(
        close: () {
          loadingOverlay.remove();
        },
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  OverlayEntry _loadingOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(10),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.loading,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
