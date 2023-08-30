enum Animations{
  login(url: "assets/animations/login.json"),
  registration(url: "assets/animations/registration.json"),
  noContent(url: "assets/animations/noContent.json"),
  loading(url: "assets/animations/loading.json"),
  error(url: "assets/animations/error.json");

  final String url;
  const Animations({required this.url});
}