import 'package:flutter/material.dart';

class BottomButtonsContainer extends StatelessWidget {
  final List<Widget>? children;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final EdgeInsets? padding;

  const BottomButtonsContainer(
      {super.key, this.children,
      this.mainAxisAlignment,
      this.crossAxisAlignment,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300]!,
                offset: const Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 4)
          ],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.end,
          crossAxisAlignment:
              crossAxisAlignment ?? CrossAxisAlignment.start,
          children: children??[],
        ),
      ),
    );
  }
}
