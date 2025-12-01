

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ImageLoader {
  static Future<String> getImageUrl(File image, String imageId) async {
    try {
      if(image.path.isEmpty) return '';

      debugPrint('--- ImageLoader getImageUrl');
      Reference storageReference = FirebaseStorage.instanceFor(bucket: dotenv.env['FIREBASE_STORAGE_BUCKET_NAME']).ref().child('images/$imageId');

      UploadTask uploadTask = storageReference.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } on FirebaseException catch (e) {
      debugPrint('--- ImageLoader getImageUrl ${e.code} ${e.message}');
      return '';
    }
  }
}