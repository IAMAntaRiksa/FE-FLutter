import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latihan_laraflutter/models/employee.dart';
import 'package:latihan_laraflutter/repositories/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepository;

  EmployeeBloc(this.employeeRepository) : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  void _onLoadEmployees(
      LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    try {
      final employees = await employeeRepository.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (_) {
      emit(EmployeeError());
    }
  }

  void _onAddEmployee(AddEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await employeeRepository.createEmployee(event.employee);
      add(LoadEmployees());
    } catch (_) {
      emit(EmployeeError());
    }
  }

  void _onUpdateEmployee(
      UpdateEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await employeeRepository.updateEmployee(event.employee);
      add(LoadEmployees());
    } catch (_) {
      emit(EmployeeError());
    }
  }

  void _onDeleteEmployee(
      DeleteEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await employeeRepository.deleteEmployee(event.id);
      add(LoadEmployees());
    } catch (_) {
      emit(EmployeeError());
    }
  }
}
