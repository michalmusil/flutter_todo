import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/config/navigation/nav_router.dart';
import 'package:todo_list/state/auth/providers/user_provider.dart';
import 'package:todo_list/utils/images.dart';

class Splash extends ConsumerWidget {
  final int delayMillis = 1500;
  final double logoSize = 200;

  const Splash({super.key});

  void _goToApp({required WidgetRef ref, required BuildContext context}) {
    Future.delayed(
      Duration(milliseconds: delayMillis),
      () {
        final userLoggedIn = ref.read(userProvider) != null;
        if (userLoggedIn) {
          NavRouter.instance().toTasks(context);
        } else {
          NavRouter.instance().toLogin(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _goToApp(ref: ref, context: context);

    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            return TweenAnimationBuilder(
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
            );
          },
        ),
      ),
    );
  }
}
