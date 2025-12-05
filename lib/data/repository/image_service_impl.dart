import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/domain/repository/image_service.dart';

class ImageServiceImpl implements ImageService {
  final _picker = ImagePicker();

  @override
  Future<File?> pickImage({required bool isCamera}) async {

    try {
      XFile? pickedFile = await _picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
      );

      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile!.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
      );

      return File(croppedFile!.path);
    } catch(e) {
      //debugPrint('--- ${e.toString()}');
      return null;
    }
  }

}