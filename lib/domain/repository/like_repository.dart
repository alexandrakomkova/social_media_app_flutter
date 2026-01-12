abstract class LikeRepository {
  Future<({int likesCount, bool isLiked})> getLikesInfo({
    required String postId,
  });

  Future<void> addLike({required String postId, required String postOwnerId});

  Future<void> removeLike({required String postId});
}
