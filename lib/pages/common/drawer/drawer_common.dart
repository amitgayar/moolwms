import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moolwms/constants/design_constants/app_icons.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/pages/indent/indent_list_page.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  Widget _navigationDrawerIcon(String assets) {
    return SvgPicture.asset(
      assets,
      height: 25,
      width: 25,
      color: Colors.white,
      fit: BoxFit.contain,
    );
  }

  bool isIndentTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    Color iconColor = Colors.white;
    return Container(
      width: size.width * 0.7,
      height: double.infinity,
      decoration: const BoxDecoration(
        // color: ColorConstants.drawerDark
        gradient: LinearGradient(colors: [
          ColorConstants.drawerLight,
          ColorConstants.drawerDark,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // const Image(
                  //     width: 32,
                  //     height: 32,
                  //     image: AssetImage(CustomIcons.logo)),
                  Text(("MoolCode"),
                      style: textTheme.headline4!.copyWith(color: iconColor)),
                ],
              ),
            ),


            ///----------------- indent --------------------
            const SizedBox(height: 0),
            ExpansionTile(
              title: Row(
                children: [
                  _navigationDrawerIcon(CustomIcons.preferences),
                  const SizedBox(width: 12),
                  Text("Indent",
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600, color: iconColor)),
                ],
              ),
              trailing: Icon(
                isIndentTileExpanded
                    ? Icons.arrow_drop_down_circle
                    : Icons.arrow_drop_down,
                color: iconColor,
              ),
              children:  <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(IndentListPage.routeName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward,
                            color: iconColor, size: 22),
                        const SizedBox(width: 8),
                        Text("Indent",
                            style: textTheme.bodySmall!.copyWith(color: iconColor)),
                      ],
                    ),
                  ),
                ),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() => isIndentTileExpanded = expanded);
              },
            ),


            ///----------------- logout --------------------

            const Spacer(),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {},
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    _navigationDrawerIcon(CustomIcons.logout),
                    const SizedBox(width: 12),
                    Text(
                        // ("logout"),
                        ("Logout"),
                        style:
                            textTheme.subtitle1!.copyWith(color: iconColor)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
