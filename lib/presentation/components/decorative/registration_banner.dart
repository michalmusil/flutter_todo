import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/utils/animations.dart';
import 'package:todo_list/utils/localization_utils.dart';

class RegistrationBanner extends StatelessWidget {
  const RegistrationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Lottie.asset(
                Animations.registration.url,
                height: 250,
              ),
              Text(
                strings(context).register,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
