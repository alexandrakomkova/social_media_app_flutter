import 'dart:io';

abstract class ImageService {
  Future<File?> pickImage(bool isCamera);
}