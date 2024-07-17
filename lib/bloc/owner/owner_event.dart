part of 'owner_bloc.dart';

abstract class OwnerEvent extends Equatable {
  const OwnerEvent();

  @override
  List<Object> get props => [];
}

class LoadOwners extends OwnerEvent {}

class AddOwner extends OwnerEvent {
  final Owner owner;

  const AddOwner(this.owner);

  @override
  List<Object> get props => [owner];
}

class UpdateOwner extends OwnerEvent {
  final Owner owner;

  const UpdateOwner(this.owner);

  @override
  List<Object> get props => [owner];
}

class DeleteOwner extends OwnerEvent {
  final int id;

  const DeleteOwner(this.id);

  @override
  List<Object> get props => [id];
}
