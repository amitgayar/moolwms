import 'package:flutter/material.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
  });

  Widget expandedValue;
  Widget headerValue;
}

class MyExpansionPanel extends StatefulWidget {
  const MyExpansionPanel({super.key, this.item});

  final Item? item;

  @override
  State<MyExpansionPanel> createState() => _MyExpansionPanelState();
}

class _MyExpansionPanelState extends State<MyExpansionPanel> {
  bool isPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _buildPanel();
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isPanelExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor:
              Colors.white.withOpacity(0.0),
              // ColorConstants.drawerDark,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: widget.item!.headerValue,
            );
          },
          body: Padding(
            padding: const EdgeInsets.only(left:16.0),
            child: widget.item!.expandedValue,
          ),
          isExpanded: isPanelExpanded,
        )
      ],
    );
  }
}
