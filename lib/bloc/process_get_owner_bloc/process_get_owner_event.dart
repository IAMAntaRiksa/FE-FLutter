part of 'process_get_owner_bloc.dart';

class ProcessGetOwnerEvent extends Equatable {
  const ProcessGetOwnerEvent();

  @override
  List<Object> get props => [];
}

class SelectOwner extends ProcessGetOwnerEvent {
  final Owner owner;

  const SelectOwner(this.owner);
}


class ResetSeletOwner extends ProcessGetOwnerEvent{}