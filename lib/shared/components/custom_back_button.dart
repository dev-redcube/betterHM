import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed, this.beforeOnPressed});

  final void Function()? beforeOnPressed;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        beforeOnPressed?.call();

        if (onPressed != null)
          onPressed!.call();
        else
          context.canPop() ? context.pop() : context.go("/");
      },
    );
  }
}
