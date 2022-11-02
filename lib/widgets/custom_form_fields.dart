import 'package:flutter/material.dart';

class FormFieldWrapper extends StatelessWidget {
  final Widget? child;
  final double? elevation;
  final EdgeInsets? margin;
  final Color? color;
  final double? radius;
  final Function()? onTap;

  const FormFieldWrapper(
      {super.key,
      this.child,
      this.elevation,
      this.margin,
      this.color,
      this.radius = 12,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.grey[100],
      margin: margin ?? const EdgeInsets.all(0),
      elevation: elevation ?? 4,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
      child: InkWell(
          borderRadius: BorderRadius.circular(24), onTap: onTap, child: child),
    );
  }
}

