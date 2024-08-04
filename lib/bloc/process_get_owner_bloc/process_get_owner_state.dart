part of 'process_get_owner_bloc.dart';

enum ProcessStatus { initial, loading, success, error, empty }

class ProcessGetOwnerState extends Equatable {
  final List<Owner> owners;
  final Owner? selectedOwner;
  final ProcessStatus status;
  final String? errorMessage;

  const ProcessGetOwnerState({
    this.owners = const [],
    this.selectedOwner,
    this.status = ProcessStatus.initial,
    this.errorMessage,
  });

  ProcessGetOwnerState copyWith({
    List<Owner>? owners,
    Owner? selectedOwner,
    ProcessStatus? status,
    String? errorMessage,
  }) {
    return ProcessGetOwnerState(
      owners: owners ?? this.owners,
      selectedOwner: selectedOwner ?? this.selectedOwner,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [owners, selectedOwner, status, errorMessage];
}


// class ProcessGetOwnerState extends Equatable {
//   final List<Owner> owners;
//   final Owner? selectedOwner;

//   const ProcessGetOwnerState({
//     this.owners = const [],
//     this.selectedOwner,
//   });

//   ProcessGetOwnerState copyWith({
//     List<Owner>? owners,
//     Owner? selectedOwner,
//   }) {
//     return ProcessGetOwnerState(
//       owners: owners ?? this.owners,
//       selectedOwner: selectedOwner ?? this.selectedOwner,
//     );
//   }

//   @override
//   List<Object?> get props => [owners, selectedOwner];
// }

// class ProcessGetOwnerInitial extends ProcessGetOwnerState {}

// class ProcessGetOwnerLoading extends ProcessGetOwnerState {}

// class ProcessGetOwnerLoaded extends ProcessGetOwnerState {
//   final List<Owner> listOwner;

//   final Owner? idOwner;

//   const ProcessGetOwnerLoaded({required this.listOwner, this.idOwner})
//       : super(owners: listOwner, selectedOwner: idOwner);

//   @override
//   List<Object?> get props => [owners, selectedOwner];
// }
