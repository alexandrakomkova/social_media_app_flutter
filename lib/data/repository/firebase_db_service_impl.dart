import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/data/model/user_model.dart';
import 'package:social_media_app/domain/repository/firebase_db_service.dart';

class FirebaseDbServiceImpl implements FirebaseDbService {
  final firestore = FirebaseFirestore.instance;
  late final _usersRef = firestore.collection('users');

  @override
  Future<void> createUser(User user, UserModel userModel) async {
    await _usersRef.doc(user.uid).set({
      'id': user.uid,
      'username': userModel.username,
      'email': userModel.email,
      'creationTime': userModel.creationTimestamp,
      'bio': userModel.bio,
      'photoUrl': user.photoURL ?? '',
    });
  }

}