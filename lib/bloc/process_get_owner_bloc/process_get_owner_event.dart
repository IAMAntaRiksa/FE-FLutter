part of 'process_get_owner_bloc.dart';

class ProcessGetOwnerEvent extends Equatable {
  const ProcessGetOwnerEvent();

  @override
  List<Object> get props => [];
}

class AddSingleDataOwner extends ProcessGetOwnerEvent {
  final Owner owner;

  const AddSingleDataOwner(this.owner);

  @override
  List<Object> get props => [owner];
}

class DeleteSingleDataOwner extends ProcessGetOwnerEvent {
  final Owner ownerId;

  const DeleteSingleDataOwner(this.ownerId);

  @override
  List<Object> get props => [ownerId];
}
