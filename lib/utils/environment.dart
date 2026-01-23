class Environment {
  Environment._();

  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET_NAME',
  );
}
