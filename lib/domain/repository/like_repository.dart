abstract class LikeRepository {
  Future<Map<String, int>> getLikesInfo({required String postId});

  Future<void> addLike({required String postId, required String postOwnerId});

  Future<void> removeLike({required String postId});
}
