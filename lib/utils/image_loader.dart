

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class ImageLoader {
  static Future<String> getImageUrl(File image, String imageId) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('images/$imageId');

    UploadTask uploadTask = storageReference.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }
}