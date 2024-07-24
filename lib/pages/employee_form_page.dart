import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_laraflutter/bloc/process_get_owner_bloc/process_get_owner_bloc.dart';
import '../bloc/employee/employee_bloc.dart';
import '../bloc/owner/owner_bloc.dart';
import '../models/employee.dart';
import '../models/owner.dart';

class EmployeeFormPage extends StatefulWidget {
  EmployeeFormPage();

  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  int _selectedOwner = 0;

  @override
  Widget build(BuildContext context) {
    ProcessGetOwnerState state = context.watch<ProcessGetOwnerBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text("addData"),
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
                  child: Text(
                    _selectedOwner == 0
                        ? 'Select owner'
                        : state is ProcessGetOwnerLoaded
                            ? state.owners
                                .firstWhere(
                                    (element) => element.id == _selectedOwner)
                                .name
                            : 'Select owner',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedOwner == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select an owner'),
                      ));
                      return;
                    }
                    BlocProvider.of<EmployeeBloc>(context).add(
                      AddEmployee(Employee(
                        name: _nameController.text,
                        job: _jobController.text,
                        ownerId: _selectedOwner,
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
                          trailing: _selectedOwner == owner.id
                              ? const Icon(Icons.radio_button_checked,
                                  color: Colors.green)
                              : const Icon(Icons.radio_button_unchecked,
                                  color: Colors.green),
                          onTap: () {
                            BlocProvider.of<ProcessGetOwnerBloc>(context)
                                .add(AddSingleDataOwner(owner));
                            _selectedOwner = owner.id;
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
