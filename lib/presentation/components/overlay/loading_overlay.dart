import 'package:flutter/material.dart';
import 'package:todo_list/presentation/components/decorative/loading_banner.dart';
import 'package:todo_list/presentation/components/overlay/overlay_controller.dart';
import 'package:todo_list/utils/localization_utils.dart';

class LoadingOverlay {
  OverlayController? _controller;

  bool get isShown => _controller != null;

  LoadingOverlay._();
  static final _instance = LoadingOverlay._();
  factory LoadingOverlay.instance() => _instance;
  
  /// Shows the loading overlay over the proveded context's screen.
  /// Only one loading overlay can be displayed at a given time.
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

  /// Hides the loading overlay if present.
  void hide() {
    _controller?.close();
    _controller = null;
  }

  OverlayEntry _loadingOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Material(
            color: Colors.black.withAlpha(150),
            child: LoadingBanner(
              loadingText: strings(context).loading,
            ));
      },
    );
  }
}
