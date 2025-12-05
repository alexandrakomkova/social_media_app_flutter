
abstract class PostRepository {
  Future<Map<String, int>> getLikesInfo({required String postId});
  Future<void> addLike({required String postId});
  Future<void> removeLike({required String postId});
}