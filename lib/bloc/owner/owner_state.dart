part of 'owner_bloc.dart';

class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object> get props => [];
}

class OwnerLoading extends OwnerState {}

class OwnerLoaded extends OwnerState {
  final List<Owner> owners;

  const OwnerLoaded(this.owners);

  @override
  List<Object> get props => [owners];
}

class OwnerError extends OwnerState {}
