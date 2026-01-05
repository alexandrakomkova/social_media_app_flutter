import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  Environment._();

  static String? firebaseStorageBucketName =
      dotenv.env['FIREBASE_STORAGE_BUCKET_NAME'];
}
