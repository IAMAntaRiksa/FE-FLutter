import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latihan_laraflutter/models/owner.dart';
import 'package:latihan_laraflutter/repositories/owner_repository.dart';

part 'owner_event.dart';
part 'owner_state.dart';

class OwnerBloc extends Bloc<OwnerEvent, OwnerState> {
  final OwnerRepository ownerRepository;

  OwnerBloc(this.ownerRepository) : super(OwnerLoading()) {
    on<LoadOwners>(_onLoadOwners);
    on<AddOwner>(_onAddOwner);
    on<UpdateOwner>(_onUpdateOwner);
    on<DeleteOwner>(_onDeleteOwner);
  }

  void _onLoadOwners(LoadOwners event, Emitter<OwnerState> emit) async {
    emit(OwnerLoading());
    try {
      final owners = await ownerRepository.getOwners();
      emit(OwnerLoaded(owners));
    } catch (_) {
      emit(OwnerError());
    }
  }

  void _onAddOwner(AddOwner event, Emitter<OwnerState> emit) async {
    try {
      await ownerRepository.createOwner(event.owner);
      add(LoadOwners());
    } catch (_) {
      emit(OwnerError());
    }
  }

  void _onUpdateOwner(UpdateOwner event, Emitter<OwnerState> emit) async {
    try {
      await ownerRepository.updateOwner(event.owner);
      add(LoadOwners());
    } catch (_) {
      emit(OwnerError());
    }
  }

  void _onDeleteOwner(DeleteOwner event, Emitter<OwnerState> emit) async {
    try {
      await ownerRepository.deleteOwner(event.id);
      add(LoadOwners());
    } catch (_) {
      emit(OwnerError());
    }
  }
}
