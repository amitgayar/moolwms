import 'package:flutter/material.dart';

class VisibilityExtended extends StatelessWidget {

  final Widget child;
  final bool? visible;
  final Widget? replacement;
  final double? opacity;

  const VisibilityExtended({super.key, required this.child, this.visible, this.replacement, this.opacity});

  @override
  Widget build(BuildContext context) {
    if(visible??true) {
      return child;
    } else {
      return replacement ?? const SizedBox.shrink();
    }
  }
}