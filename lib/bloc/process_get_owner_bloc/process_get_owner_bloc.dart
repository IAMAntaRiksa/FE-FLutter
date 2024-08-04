import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latihan_laraflutter/models/owner.dart';

part 'process_get_owner_event.dart';
part 'process_get_owner_state.dart';

class ProcessGetOwnerBloc
    extends Bloc<ProcessGetOwnerEvent, ProcessGetOwnerState> {
  ProcessGetOwnerBloc() : super(const ProcessGetOwnerState()) {
    on<SelectOwner>((event, emit) {
      emit(state.copyWith(
        status: ProcessStatus.success,
        selectedOwner: event.owner,
      ));
    });

    on<ResetSeletOwner>((event, emit) {
      emit(state.copyWith(
        status: ProcessStatus.success,
        selectedOwner: Owner(id: 0, name: ''),
      ));
    });
  }
}
