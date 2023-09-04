class OverlayController {
  final void Function() close;
  final void Function()? update;

  OverlayController({
    required this.close,
    this.update,
  });
}
