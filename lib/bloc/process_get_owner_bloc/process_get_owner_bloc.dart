import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latihan_laraflutter/models/owner.dart';

part 'process_get_owner_event.dart';
part 'process_get_owner_state.dart';

class ProcessGetOwnerBloc
    extends Bloc<ProcessGetOwnerEvent, ProcessGetOwnerState> {
  List<Owner> owners = [];
  ProcessGetOwnerBloc() : super(ProcessGetOwnerInitial()) {
    on<AddSingleDataOwner>((event, emit) {
      emit(ProcessGetOwnerInitial());
      var contains = owners.where((element) => element.id == event.owner.id);
      if (contains.isEmpty) {
        owners.add(event.owner);
      } else {
        owners[owners.indexWhere((e) => e.id == event.owner.id)] = event.owner;
      }
      emit(ProcessGetOwnerLoaded(owners: owners));
    });
    on<DeleteSingleDataOwner>((event, emit) {
      emit(ProcessGetOwnerInitial());
      owners.remove(event.ownerId);
      emit(ProcessGetOwnerLoaded(owners: owners));
    });
  }
}
