import 'package:intl/intl.dart';
import 'package:social_media_app/domain/model/user_entity.dart';

class PostEntity {
  String userId;
  final UserEntity userEntity;
  String description;
  String imageUrl;
  int? creationTimestamp;

  PostEntity({
    this.userId = '',
    required this.userEntity,
    this.imageUrl = '',
    this.description = '',
    this.creationTimestamp = 0,
  });

  DateTime get creationTimestampDateTime => DateTime.fromMillisecondsSinceEpoch(creationTimestamp ?? 0);
  String get formattedCreationTimestamp => DateFormat('dd/MM/yyyy HH:mm').format(creationTimestampDateTime);
  int get id => creationTimestamp ?? 0;
}