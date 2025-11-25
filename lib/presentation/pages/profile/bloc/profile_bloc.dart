import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_media_app/domain/repository/auth/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository, super(const ProfileState.idle()) {
    on<ProfileEvent>((events, emit) async {
      await events.map(
        signOut: (_) => _signOut(emit),
      );
    });
  }

  Future<void> _signOut(Emitter<ProfileState> emit) async {
    emit(ProfileState.processing());

    try {
      await _authRepository.signOut();

      emit(ProfileState.success());
    } catch(e) {
      emit(ProfileState.failed());
    }
  }
}
