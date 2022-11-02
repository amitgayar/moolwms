import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moolwms/constants/Constants.dart';
import 'package:moolwms/constants/design_constants/color_constants.dart';
import 'package:moolwms/utils/dev_utils.dart';


class ImageUtils {
  static Future<CroppedFile?> pickAndCropImageWithSourceSelection(BuildContext context,
      [int? maxWidth, int? maxHeight]) async {
    ImageSource source = await showModalBottomSheet(
        context: context,
        builder: (context) {
          var textTheme = Theme.of(context).textTheme;
          return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(("select_method"),
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(ImageSource.camera);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.primary, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera,
                                    color: ColorConstants.primary),
                                const SizedBox(height: 4),
                                Text(
                                    // ("camera"),
                                    ("Camera"),
                                    style: textTheme.button!.copyWith(color: ColorConstants.primary))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop(ImageSource.gallery);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorConstants.primary, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 const Icon(Icons.photo_library,
                                    color: ColorConstants.primary),
                                const SizedBox(height: 4),
                                Text(
                                    // ("gallery"),
                                    ("Gallery"),
                                    style: textTheme
                                        .button!
                                        .copyWith(
                                        color: ColorConstants.primary))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ));
        });
    return await pickAndCropImage(source, maxWidth!, maxHeight!);
  }

  static Future<CroppedFile?> pickAndCropImage(ImageSource imageSource, [int? maxWidth, int? maxHeight]) async {
    logPrint.v("picking and cropping file");

    ImagePicker picker = ImagePicker();
    // PickedFile? pickedFile = (await picker.pickImage(source: imageSource, imageQuality: 50)) as PickedFile?;
    final XFile? pickedFile = await picker.pickImage(source: imageSource);




    // final File file = File(pickedFile!.path);

    if (pickedFile != null) {
      var croppedFile = (await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxWidth: maxWidth ?? 800,
          maxHeight: maxHeight,
          compressQuality: 50,
          aspectRatio: maxWidth != null && maxHeight != null
              ? CropAspectRatio(
              ratioX: maxWidth.toDouble(), ratioY: maxHeight.toDouble())
              : null)) as CroppedFile;
      // return null;

      return croppedFile;
    }
    return null;
  }

  static Widget loadImage(String url,
      {double? height, double? width, Color? color, BoxFit? fit}) {
    return Image.network(
      url,
      height: height,
      color: color,
      fit: fit,
      width: width,
      headers: const {
        "source": APIConstants.apiSource,
        "version": APIConstants.apiVersion,
        "Accept": "application/json",


        //todo: must do it
        "Authorization": 'globals.token'
      },
    );
  }
}

class FileContainerAPIs {

  static String getFileURL(vehicleInsuranceImageContainer, vehicleRcImage) {
    return "";
  }
}