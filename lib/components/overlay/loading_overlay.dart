import 'package:flutter/material.dart';
import 'package:todo_list/components/decorative/loading_banner.dart';
import 'package:todo_list/components/overlay/overlay_controller.dart';
import 'package:todo_list/utils/localization_utils.dart';

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
            color: Colors.black.withAlpha(150),
            child: LoadingBanner(
              loadingText: strings(context).loading,
            ));
      },
    );
  }
}
