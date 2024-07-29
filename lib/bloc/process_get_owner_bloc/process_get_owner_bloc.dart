import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latihan_laraflutter/models/owner.dart';

part 'process_get_owner_event.dart';
part 'process_get_owner_state.dart';

class ProcessGetOwnerBloc
    extends Bloc<ProcessGetOwnerEvent, ProcessGetOwnerState> {
  ProcessGetOwnerBloc() : super(ProcessGetOwnerInitial()) {
    on<SelectOwner>((event, emit) {
      emit(ProcessGetOwnerLoaded(
        listOwner: state.owners,
        idOwner: event.owner,
      ));
    });

    on<ResetSeletOwner>((event, emit) {
      emit(ProcessGetOwnerLoaded(
          listOwner: state.owners, idOwner: Owner(id: 0, name: '')));
    });
  }
}
