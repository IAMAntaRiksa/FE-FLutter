import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_laraflutter/bloc/process_get_owner_bloc/process_get_owner_bloc.dart';
import 'package:latihan_laraflutter/pages/widgets/show_buttomsheet.dart';
import '../bloc/employee/employee_bloc.dart';
import '../models/employee.dart';

class EmployeeFormPage extends StatefulWidget {
  EmployeeFormPage();

  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProcessGetOwnerBloc>(context).add(ResetSeletOwner());
  }

  @override
  Widget build(BuildContext context) {
    ProcessGetOwnerState ownerState =
        context.watch<ProcessGetOwnerBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text("addData"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobController,
                decoration: const InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  showOwnerSelectionBottomSheet(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    ownerState.status == ProcessStatus.success &&
                            ownerState.selectedOwner!.id != 0
                        ? ownerState.selectedOwner!.name
                        : 'Select owner',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (ownerState.status != ProcessStatus.success ||
                        ownerState.selectedOwner == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select an owner'),
                      ));
                      return;
                    }
                    BlocProvider.of<EmployeeBloc>(context).add(
                      AddEmployee(Employee(
                        name: _nameController.text,
                        job: _jobController.text,
                        ownerId: ownerState.selectedOwner!.id,
                      )),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
