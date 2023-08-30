import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_list/utils/animations.dart';

class NoContentBanner extends StatelessWidget {
  final String? title;
  final String? text;
  const NoContentBanner({
    super.key,
    this.title,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final availableHeight = MediaQuery.of(context).size.height;

    return Center(
      child: SizedBox(
        width: availableWidth * 0.8,
        height: availableHeight * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              Animations.noContent.url,
              height: availableHeight * 0.5,
            ),
            if (title != null)
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            if (text != null)
              Text(
                text!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
