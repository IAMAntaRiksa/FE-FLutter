part of 'process_get_owner_bloc.dart';

class ProcessGetOwnerState extends Equatable {
  const ProcessGetOwnerState();

  @override
  List<Object> get props => [];
}

class ProcessGetOwnerInitial extends ProcessGetOwnerState {}

class ProcessGetOwnerLoading extends ProcessGetOwnerState {}

class ProcessGetOwnerLoaded extends ProcessGetOwnerState {
  final List<Owner> owners;

  const ProcessGetOwnerLoaded({required this.owners});

  @override
  List<Object> get props => [owners];
}
