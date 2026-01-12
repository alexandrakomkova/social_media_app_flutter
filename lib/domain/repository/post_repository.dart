import 'package:social_media_app/domain/repository/comment_repository.dart';
import 'package:social_media_app/domain/repository/like_repository.dart';

abstract class PostRepository implements LikeRepository, CommentRepository {}
