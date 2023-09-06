import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/domain/services/auth_service_base.dart';
import 'package:todo_list/locator.dart';
import 'package:todo_list/utils/images.dart';

class Splash extends StatelessWidget {
  final AuthServiceBase _authService = locator<AuthServiceBase>();
  final int delayMillis = 1500;
  final double logoSize = 200;

  Splash({super.key});

  void _goToApp({required BuildContext context}) {
    Future.delayed(
      Duration(milliseconds: delayMillis),
      () {
        final userLoggedIn = _authService.user != null;
        if (userLoggedIn) {
          NavRouter.instance().toTasks(context);
        } else {
          NavRouter.instance().toLogin(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _goToApp(context: context);

    return Scaffold(
      body: SafeArea(
        child: TweenAnimationBuilder(
          tween: Tween(
            begin: 0.0,
            end: logoSize,
          ),
          curve: Curves.elasticOut,
          duration: Duration(
            milliseconds: (delayMillis * 0.8).toInt(),
          ),
          builder: (context, size, child) {
            return Center(
              child: SvgPicture.asset(
                Images.appLogo.url,
                height: size,
              ),
            );
          },
        ),
      ),
    );
  }
}
