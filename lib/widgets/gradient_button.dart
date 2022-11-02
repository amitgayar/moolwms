import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';

enum Width { wrap, full }

class GradientButton extends StatelessWidget {
  final Icon? icon;
  final Widget? child;
  final VoidCallback? onPressed;
  final double radius;
  final EdgeInsetsGeometry padding;
  final List<Color> colors;
  final Width? width;
  final bool enabled;

  const GradientButton(
      {super.key,
      this.child,
      this.radius = 24,
      this.enabled = true,
      this.padding = const EdgeInsets.all(0),
      this.colors = const [ColorConstants.buttonLight, ColorConstants.buttonDark],
      this.onPressed,
      this.width,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final childWidget = Container(
      width: width == Width.full ? double.infinity : null,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: enabled ? colors : [Colors.grey, Colors.grey],
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      padding: EdgeInsets.symmetric(horizontal: 36, vertical: (icon != null) ? 10 : 12),
      child: Row(
        mainAxisSize: width == Width.full ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon,
          ) : const Text(""),
          child!
        ],
      ),
    );

    return ElevatedButton(
      onPressed: enabled ? onPressed! : null,
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor: enabled ? colors[0] : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),

      child: childWidget,
    );
  }
}
