enum Routes {
  login(route: '/login'),
  registration(route: '/register'),
  tasks(route: '/tasks'),
  taskDetail(route: '/task_detail'),
  taskCreateOrUpdate(route: '/task_create_update');


  final String route;
  const Routes({required this.route});
}