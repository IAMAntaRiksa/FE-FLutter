import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee/employee_bloc.dart';
import '../bloc/owner/owner_bloc.dart';
import '../models/employee.dart';
import '../models/owner.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;

  EmployeeFormPage({this.employee});

  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _job;
  Owner? _selectedOwner;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _name = widget.employee!.name;
      _job = widget.employee!.job;
      _selectedOwner = null;

      // Load the selected owner based on the employee's ownerId
      _loadSelectedOwner(widget.employee!.ownerId);
    } else {
      _name = '';
      _job = '';
      _selectedOwner = null;
    }

    // Load owners if not already loaded
    if (BlocProvider.of<OwnerBloc>(context).state is! OwnerLoaded) {
      BlocProvider.of<OwnerBloc>(context).add(LoadOwners());
    }
  }

  void _loadSelectedOwner(int ownerId) {
    final ownerState = BlocProvider.of<OwnerBloc>(context).state;
    if (ownerState is OwnerLoaded) {
      final owner = ownerState.owners.firstWhere(
        (owner) => owner.id == ownerId,
        orElse: () => Owner(id: 0, name: 'Unknown'),
      );
      setState(() {
        _selectedOwner = owner;
      });
    } else {
      // Wait for owners to load and then set the selected owner
      BlocProvider.of<OwnerBloc>(context).stream.listen((state) {
        if (state is OwnerLoaded) {
          final owner = state.owners.firstWhere(
            (owner) => owner.id == ownerId,
            orElse: () => Owner(id: 0, name: 'Unknown'),
          );
          setState(() {
            _selectedOwner = owner;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _job,
                decoration: InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _job = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  _showOwnerSelectionBottomSheet(context);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Owner',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(_selectedOwner?.name ?? 'Select Owner'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_selectedOwner == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select an owner'),
                      ));
                      return;
                    }

                    if (widget.employee == null) {
                      BlocProvider.of<EmployeeBloc>(context).add(
                        AddEmployee(Employee(
                          id: 0,
                          name: _name,
                          job: _job,
                          ownerId: _selectedOwner!.id,
                        )),
                      );
                    } else {
                      BlocProvider.of<EmployeeBloc>(context).add(
                        UpdateEmployee(Employee(
                          id: widget.employee!.id,
                          name: _name,
                          job: _job,
                          ownerId: _selectedOwner!.id,
                        )),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
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
              return Center(child: CircularProgressIndicator());
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
                          trailing: _selectedOwner?.id == owner.id
                              ? Icon(Icons.radio_button_checked,
                                  color: Colors.green)
                              : Icon(Icons.radio_button_unchecked,
                                  color: Colors.green),
                          onTap: () {
                            setState(() {
                              _selectedOwner = owner;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is OwnerError) {
              return Center(child: Text('Failed to load owners'));
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}




// ketika relog ke halam edit dia error malah ke select owner untk kode dibawah ini
// class EmployeeFormPage extends StatefulWidget {
//   final Employee? employee;

//   EmployeeFormPage({this.employee});

//   @override
//   _EmployeeFormPageState createState() => _EmployeeFormPageState();
// }

// class _EmployeeFormPageState extends State<EmployeeFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   late String _name;
//   late String _job;
//   Owner? _selectedOwner;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.employee != null) {
//       _name = widget.employee!.name;
//       _job = widget.employee!.job;
//       _selectedOwner = null;

//       // Load the selected owner based on the employee's ownerId
//       _loadSelectedOwner(widget.employee!.ownerId);
//     } else {
//       _name = '';
//       _job = '';
//       _selectedOwner = null;
//     }

//     // Load owners if not already loaded
//     if (BlocProvider.of<OwnerBloc>(context).state is! OwnerLoaded) {
//       BlocProvider.of<OwnerBloc>(context).add(LoadOwners());
//     }
//   }

//   void _loadSelectedOwner(int ownerId) {
//     final ownerState = BlocProvider.of<OwnerBloc>(context).state;
//     if (ownerState is OwnerLoaded) {
//       final owner = ownerState.owners.firstWhere(
//         (owner) => owner.id == ownerId,
//         orElse: () => Owner(id: 0, name: 'Unknown'),
//       );
//       setState(() {
//         _selectedOwner = owner;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: _name,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 onSaved: (value) {
//                   _name = value!;
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 initialValue: _job,
//                 decoration: InputDecoration(
//                   labelText: 'Job',
//                   border: OutlineInputBorder(),
//                 ),
//                 onSaved: (value) {
//                   _job = value!;
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a job';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () {
//                   _showOwnerSelectionBottomSheet(context);
//                 },
//                 child: InputDecorator(
//                   decoration: InputDecoration(
//                     labelText: 'Owner',
//                     border: OutlineInputBorder(),
//                   ),
//                   child: Text(_selectedOwner?.name ?? 'Select Owner'),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     if (_selectedOwner == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Please select an owner'),
//                       ));
//                       return;
//                     }

//                     if (widget.employee == null) {
//                       BlocProvider.of<EmployeeBloc>(context).add(
//                         AddEmployee(Employee(
//                           id: 0,
//                           name: _name,
//                           job: _job,
//                           ownerId: _selectedOwner!.id,
//                         )),
//                       );
//                     } else {
//                       BlocProvider.of<EmployeeBloc>(context).add(
//                         UpdateEmployee(Employee(
//                           id: widget.employee!.id,
//                           name: _name,
//                           job: _job,
//                           ownerId: _selectedOwner!.id,
//                         )),
//                       );
//                     }
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showOwnerSelectionBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return BlocBuilder<OwnerBloc, OwnerState>(
//           builder: (context, state) {
//             if (state is OwnerLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is OwnerLoaded) {
//               return Column(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Select Owner',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: state.owners.length,
//                       itemBuilder: (context, index) {
//                         final owner = state.owners[index];
//                         return ListTile(
//                           title: Text(owner.name),
//                           trailing: _selectedOwner?.id == owner.id
//                               ? Icon(Icons.radio_button_checked,
//                                   color: Colors.green)
//                               : Icon(Icons.radio_button_unchecked,
//                                   color: Colors.green),
//                           onTap: () {
//                             setState(() {
//                               _selectedOwner = owner;
//                             });
//                             Navigator.pop(context);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else if (state is OwnerError) {
//               return Center(child: Text('Failed to load owners'));
//             } else {
//               return Container();
//             }
//           },
//         );
//       },
//     );
//   }
// }

// class EmployeeFormPage extends StatefulWidget {
//   final Employee? employee;

//   EmployeeFormPage({this.employee});

//   @override
//   _EmployeeFormPageState createState() => _EmployeeFormPageState();
// }

// class _EmployeeFormPageState extends State<EmployeeFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   late String _name;
//   late String _job;
//   Owner? _selectedOwner;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.employee != null) {
//       _name = widget.employee!.name;
//       _job = widget.employee!.job;
//       _selectedOwner = Owner(id: widget.employee!.ownerId, name: '');
//     } else {
//       _name = '';
//       _job = '';
//       _selectedOwner = null;
//     }

//     // Load owners if not already loaded
//     if (BlocProvider.of<OwnerBloc>(context).state is! OwnerLoaded) {
//       BlocProvider.of<OwnerBloc>(context).add(LoadOwners());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: _name,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onSaved: (value) {
//                   _name = value!;
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _job,
//                 decoration: InputDecoration(labelText: 'Job'),
//                 onSaved: (value) {
//                   _job = value!;
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a job';
//                   }
//                   return null;
//                 },
//               ),
//               ListTile(
//                 title: Text(_selectedOwner?.name ?? 'Select Owner'),
//                 trailing: Icon(Icons.arrow_drop_down),
//                 onTap: () {
//                   _showOwnerSelectionBottomSheet(context);
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     if (_selectedOwner == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text('Please select an owner'),
//                       ));
//                       return;
//                     }

//                     if (widget.employee == null) {
//                       BlocProvider.of<EmployeeBloc>(context).add(
//                         AddEmployee(Employee(
//                           id: 0,
//                           name: _name,
//                           job: _job,
//                           ownerId: _selectedOwner!.id,
//                         )),
//                       );
//                     } else {
//                       BlocProvider.of<EmployeeBloc>(context).add(
//                         UpdateEmployee(Employee(
//                           id: widget.employee!.id,
//                           name: _name,
//                           job: _job,
//                           ownerId: _selectedOwner!.id,
//                         )),
//                       );
//                     }
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showOwnerSelectionBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return BlocBuilder<OwnerBloc, OwnerState>(
//           builder: (context, state) {
//             if (state is OwnerLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is OwnerLoaded) {
//               return ListView.builder(
//                 itemCount: state.owners.length,
//                 itemBuilder: (context, index) {
//                   final owner = state.owners[index];
//                   return ListTile(
//                     title: Text(owner.name),
//                     onTap: () {
//                       setState(() {
//                         _selectedOwner = owner;
//                       });
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               );
//             } else if (state is OwnerError) {
//               return Center(child: Text('Failed to load owners'));
//             } else {
//               return Container();
//             }
//           },
//         );
//       },
//     );
//   }
// }
