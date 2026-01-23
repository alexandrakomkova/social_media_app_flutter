import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/utils/environment.dart';

final _log = Logger('ImageLoader');

abstract class ImageLoader {
  static Future<String> getImageUrl(File image, String imageId) async {
    try {
      if (image.path.isEmpty) return '';

      Reference storageReference = FirebaseStorage.instanceFor(
        bucket: Environment.firebaseStorageBucket,
      ).ref().child('images/$imageId');

      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        _log.info('image is loaded to FirebaseStorage');
      });
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } on FirebaseException catch (e) {
      _log.warning('getImageUrl error: ${e.code} ${e.message}');
      return '';
    } on Exception catch (e) {
      _log.warning('getImageUrl error: $e');
      return '';
    }
  }
}
