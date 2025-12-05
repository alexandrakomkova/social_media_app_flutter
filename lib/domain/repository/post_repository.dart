
abstract class PostRepository {
  Future<Map<String, int>> getLikesInfo(String postId);
  Future<void> addLike(String postId);
  Future<void> removeLike(String postId);
}