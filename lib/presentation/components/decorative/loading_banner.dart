import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/utils/animations.dart';

class LoadingBanner extends StatelessWidget {
  final String loadingText;

  const LoadingBanner({
    super.key,
    required this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            Animations.loading.url,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            loadingText,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          )
        ],
      ),
    );
  }
}
