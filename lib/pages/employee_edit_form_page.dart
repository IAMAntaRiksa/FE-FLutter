import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_laraflutter/bloc/process_get_owner_bloc/process_get_owner_bloc.dart';
import 'package:latihan_laraflutter/models/owner.dart';
import '../bloc/employee/employee_bloc.dart';
import '../bloc/owner/owner_bloc.dart';
import '../models/employee.dart';

class EmployeeEditFormPage extends StatefulWidget {
  final Employee? employee;

  EmployeeEditFormPage({this.employee});

  @override
  _EmployeeEditFormPageState createState() => _EmployeeEditFormPageState();
}

class _EmployeeEditFormPageState extends State<EmployeeEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _jobController;

  Employee get employee => widget.employee!;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: employee.name);
    _jobController = TextEditingController(text: employee.job);

    // Set selected owner in BLoC
    context
        .read<ProcessGetOwnerBloc>()
        .add(SelectOwner(Owner(id: employee.ownerId, name: '')));


        

    // Trigger the process to fetch owners
    context.read<OwnerBloc>().add(LoadOwners());
  }

  @override
  Widget build(BuildContext context) {
    ProcessGetOwnerState ownerState =
        context.watch<ProcessGetOwnerBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
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
                  _showOwnerSelectionBottomSheet(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                  child: BlocSelector<OwnerBloc, OwnerState, List<Owner>>(
                    selector: (state) {
                      if (state is OwnerLoaded) {
                        return state.owners;
                      }
                      return [];
                    },
                    builder: (context, owners) {
                      if (owners.isNotEmpty) {
                        var id = context
                            .read<ProcessGetOwnerBloc>()
                            .state
                            .selectedOwner!
                            .id;
                        return Text(
                          id == 0
                              ? 'Select owner'
                              : owners
                                  .firstWhere((owner) => owner.id == id)
                                  .name,
                        );
                      } else if (context.read<OwnerBloc>().state
                          is OwnerError) {
                        return const Center(
                            child: Text('Failed to load owners'));
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (ownerState is! ProcessGetOwnerLoaded ||
                        ownerState.selectedOwner == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select an owner'),
                      ));
                      return;
                    }
                    BlocProvider.of<EmployeeBloc>(context).add(
                      UpdateEmployee(Employee(
                        id: widget.employee!.id,
                        name: _nameController.text,
                        job: _jobController.text,
                        ownerId: ownerState.selectedOwner!.id,
                      )),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOwnerSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocBuilder<OwnerBloc, OwnerState>(
          builder: (context, state) {
            if (state is OwnerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OwnerLoaded) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Select Owner',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.owners.length,
                      itemBuilder: (context, index) {
                        final owner = state.owners[index];
                        return ListTile(
                          title: Text(owner.name),
                          trailing: context
                                      .read<ProcessGetOwnerBloc>()
                                      .state
                                      .selectedOwner
                                      ?.id ==
                                  owner.id
                              ? const Icon(Icons.radio_button_checked,
                                  color: Colors.green)
                              : const Icon(Icons.radio_button_unchecked,
                                  color: Colors.green),
                          onTap: () {
                            context
                                .read<ProcessGetOwnerBloc>()
                                .add(SelectOwner(owner));
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is OwnerError) {
              return const Center(child: Text('Failed to load owners'));
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
