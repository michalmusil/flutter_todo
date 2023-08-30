import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/utils/animations.dart';
import 'package:todo_list/utils/localization_utils.dart';

class LoginBanner extends StatelessWidget {
  const LoginBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            Animations.login.url,
            height: 250,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            strings(context).login,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          )
        ],
      ),
    );
  }
}
