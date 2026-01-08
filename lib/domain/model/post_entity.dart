import 'package:intl/intl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

class PostEntity {
  final String userId;
  final UserEntity userEntity;
  final String description;
  final String imageUrl;
  final int creationTimestamp;

  PostEntity({
    required this.userId,
    required this.userEntity,
    required this.description,
    required this.imageUrl,
    required this.creationTimestamp,
  });

  DateTime get creationTimestampDateTime =>
      DateTime.fromMillisecondsSinceEpoch(creationTimestamp);

  String get formattedCreationTimestamp =>
      DateFormat('dd/MM/yyyy HH:mm').format(creationTimestampDateTime);

  int get id => creationTimestamp;
}
