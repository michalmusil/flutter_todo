enum Images{
  appIcon(url: 'assets/app_icon.svg'),
  appLogo(url: 'assets/app_logo.svg');

  final String url;
  const Images({required this.url});
}