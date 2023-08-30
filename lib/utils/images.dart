enum Images{
  appIcon(url: 'assets/icons/app_icon.svg'),
  appLogo(url: 'assets/icons/app_logo.svg');

  final String url;
  const Images({required this.url});
}