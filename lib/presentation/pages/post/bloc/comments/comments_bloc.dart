import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/repository/comment_repository.dart';
import 'package:social_media_app/presentation/model/pagination.dart';

part 'comments_bloc.freezed.dart';
part 'comments_event.dart';
part 'comments_state.dart';

final _log = Logger('CommentsBloc');

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentRepository _commentRepository;

  CommentsBloc({
    required CommentRepository commentRepository,
    required String postId,
    required String postOwnerId,
  }) : _commentRepository = commentRepository,
       super(
         CommentsState.idle(
           postId: postId,
           postOwnerId: postOwnerId,
           pagination: Pagination<CommentEntity>.empty(),
         ),
       ) {
    on<CommentsEvent>((event, emit) async {
      switch (event) {
        case _GetComments():
          await _getComments(emit);
        case _AddComment():
          await _addComment(emit);
        case _CommentTextChanged():
          await _commentTextChanged(event, emit);
        case _GetCommentsInfo():
          await _getCommentsInfo(emit);
      }
    }, transformer: droppable());
  }

  factory CommentsBloc.getComments({
    required CommentRepository commentRepository,
    required String postId,
    required String postOwnerId,
  }) => CommentsBloc(
    commentRepository: commentRepository,
    postId: postId,
    postOwnerId: postOwnerId,
  )..add(CommentsEvent.getCommentsInfo());

  Future<void> _getCommentsInfo(Emitter<CommentsState> emit) async {
    emit(
      CommentsState.processing(
        postId: state.postId,
        postOwnerId: state.postOwnerId,
        commentsCount: state.commentsCount,
        pagination: state.pagination,
      ),
    );

    try {
      final commentsCount = await _commentRepository.getCommentsCount(
        postId: state.postId,
      );

      final res = await _commentRepository.getComments(
        postId: state.postId,
        lastDoc: state.pagination.lastDoc,
      );

      state.pagination.addItemsToList(res.list);

      _log.info('_getCommentsInfo success');

      emit(
        CommentsState.success(
          postId: state.postId,
          postOwnerId: state.postOwnerId,
          commentsCount: commentsCount,
          pagination: state.pagination.copyWith(
            hasMoreToLoad: res.hasMoreToLoad,
            lastDoc: res.lastDoc,
          ),
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        CommentsState.failed(
          postId: state.postId,
          postOwnerId: state.postOwnerId,
          commentsCount: state.commentsCount,
          pagination: state.pagination.copyWith(hasMoreToLoad: false),
        ),
      );
    }
  }

  Future<void> _getComments(Emitter<CommentsState> emit) async {
    emit(
      CommentsState.processing(
        postId: state.postId,
        postOwnerId: state.postOwnerId,
        pagination: state.pagination,
        commentsCount: state.commentsCount,
      ),
    );

    try {
      final res = await _commentRepository.getComments(
        postId: state.postId,
        lastDoc: state.pagination.lastDoc,
      );

      state.pagination.addItemsToList(res.list);

      _log.info('_getComments success');

      emit(
        CommentsState.success(
          postId: state.postId,
          postOwnerId: state.postOwnerId,
          pagination: state.pagination.copyWith(
            lastDoc: res.lastDoc,
            hasMoreToLoad: res.hasMoreToLoad,
          ),
          commentsCount: state.commentsCount,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        CommentsState.failed(
          postId: state.postId,
          postOwnerId: state.postOwnerId,
          pagination: state.pagination.copyWith(hasMoreToLoad: false),
          commentsCount: state.commentsCount,
        ),
      );
    }
  }

  Future<void> _addComment(Emitter<CommentsState> emit) async {
    try {
      await _commentRepository.addComment(
        postId: state.postId,
        commentText: state.commentText,
        postOwnerId: state.postOwnerId,
      );

      emit(
        CommentsState.success(
          postId: state.postId,
          pagination: state.pagination,
          postOwnerId: state.postOwnerId,
          commentsCount: state.commentsCount + 1,
        ),
      );
    } catch (e) {
      _log.warning(e.toString());
      emit(
        CommentsState.failed(
          pagination: state.pagination,
          postId: state.postId,
          postOwnerId: state.postOwnerId,
          commentsCount: state.commentsCount,
        ),
      );
    }
  }

  Future<void> _commentTextChanged(
    _CommentTextChanged event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(commentText: event.commentText));
  }
}
