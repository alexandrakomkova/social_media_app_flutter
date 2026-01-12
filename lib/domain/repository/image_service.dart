import 'dart:io';

abstract class ImageService {
  Future<File?> pickImage({required bool isCamera});
}
