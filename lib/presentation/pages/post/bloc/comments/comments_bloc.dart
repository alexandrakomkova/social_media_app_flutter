import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/model/comment_entity.dart';
import 'package:social_media_app/domain/repository/comment_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';
part 'comments_bloc.freezed.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentRepository _commentRepository;

  CommentsBloc({
    required CommentRepository commentRepository,
    required String postId,
    required String postOwnerId,
  }) : _commentRepository = commentRepository,
       super(CommentsState.idle(postId: postId, postOwnerId: postOwnerId)) {
    on<CommentsEvent>((events, emit) async {
      await events.map(
        getComments: (_) => _getComments(emit),
        addComment: (_) => _addComment(emit),
        commentTextChanged: (event) => _commentTextChanged(event, emit),
      );
    });
  }

  factory CommentsBloc.getComments({
    required CommentRepository commentRepository,
    required String postId,
    required String postOwnerId,
  }) => CommentsBloc(
    commentRepository: commentRepository,
    postId: postId,
    postOwnerId: postOwnerId,
  )..add(CommentsEvent.getComments());

  Future<void> _getComments(Emitter<CommentsState> emit) async {
    emit(CommentsState.processing(
      postId: state.postId,
      postOwnerId: state.postOwnerId,

    ));

    try {
      final res = await _commentRepository.getComments(postId: state.postId);

      emit(CommentsState.success(
        postId: state.postId,
        comments: res,
        postOwnerId: state.postOwnerId,
      ));
    } catch(e) {
      emit(CommentsState.failed(
        comments: [],
        postId: state.postId,
        postOwnerId: state.postOwnerId,
      ));
    }
  }

  Future<void> _addComment(Emitter<CommentsState> emit) async {
    try {
      await _commentRepository.addComment(
        postId: state.postId,
        commentText: state.commentText,
        postOwnerId: state.postOwnerId,
      );

      emit(CommentsState.success(
        postId: state.postId,
        comments: state.comments,
        postOwnerId: state.postOwnerId,
      ));
    } catch(e) {
      emit(CommentsState.failed(
        comments: state.comments,
        postId: state.postId,
        postOwnerId: state.postOwnerId,
      ));
    }
  }

  Future<void> _commentTextChanged(_CommentTextChanged event, Emitter<CommentsState> emit) async {
    emit(state.copyWith(commentText: event.commentText));
  }
}
