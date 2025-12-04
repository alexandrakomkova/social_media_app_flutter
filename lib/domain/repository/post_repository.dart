
abstract class PostRepository {
  Future<int> getLikesCount(String postId);
  Future<void> addLike(String postId);
  Future<void> removeLike(String postId);
}