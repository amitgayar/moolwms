import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/utils/dev_utils.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:shimmer/shimmer.dart';


class SingleFullImage extends StatefulWidget {
  final String? image;
  final String? screenSet;
  const SingleFullImage(this.image, this.screenSet, {Key? key}) : super(key: key);

  @override
  SingleFullImageState createState() => SingleFullImageState();
}

class SingleFullImageState extends State<SingleFullImage>
    with SingleTickerProviderStateMixin {
    late TransformationController transformationController;
  late TapDownDetails tapDownDetails;
    late AnimationController animationController;
  late Animation<Matrix4> animation;

  int count = 0;
  @override
  void initState() {
    super.initState();

    transformationController = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
          ..addListener(() {
            transformationController.value = animation.value;
          });
    logPrint.w("Here i get the index on tap $count");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppColor.behan6,
      appBar: AppBar(
        title: Text(widget.screenSet??""),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: GestureDetector(
                onDoubleTap: () {
                  final position = tapDownDetails.localPosition;
                  const double scale = 3;
                  final x = -position.dx * (scale - 1);
                  final y = -position.dy * (scale - 1);
                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);
                  final value = transformationController.value.isIdentity()
                      ? zoomed
                      : Matrix4.identity();
                  animation = Matrix4Tween(
                    begin: transformationController.value,
                    end: value,
                  ).animate(CurveTween(curve: Curves.easeOut)
                      .animate(animationController));
                  transformationController.value = value;
                  animationController.forward(from: 0);
                },
                onDoubleTapDown: (details) => tapDownDetails = details,
                child: InteractiveViewer(
                  panEnabled: false, // Set it to false
                  clipBehavior: Clip.none,
                  scaleEnabled: false,
                  transformationController: transformationController,
                  child: PinchZoom(
                    resetDuration: const Duration(milliseconds: 100),
                    maxScale: 5.0,
                    zoomEnabled: true,
                    onZoomStart: () {
                      logPrint.w('Start zooming');
                    },
                    onZoomEnd: () {
                      logPrint.w('Stop zooming');
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.image??"",
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: ColorConstants.offWhite,
                        period: const Duration(milliseconds: 1000),
                        child: Container(
                          height: double.infinity,
                          decoration: const BoxDecoration(color: ColorConstants.offWhite),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
