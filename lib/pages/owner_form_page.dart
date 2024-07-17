import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/owner/owner_bloc.dart';
import '../models/owner.dart';

class OwnerFormPage extends StatefulWidget {
  final Owner? owner;

  OwnerFormPage({this.owner});

  @override
  _OwnerFormPageState createState() => _OwnerFormPageState();
}

class _OwnerFormPageState extends State<OwnerFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _name;

  @override
  void initState() {
    super.initState();
    if (widget.owner != null) {
      _name = widget.owner!.name;
    } else {
      _name = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner == null ? 'Add Owner' : 'Edit Owner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.owner == null) {
                      BlocProvider.of<OwnerBloc>(context).add(
                        AddOwner(Owner(
                          id: 0,
                          name: _name,
                        )),
                      );
                    } else {
                      BlocProvider.of<OwnerBloc>(context).add(
                        UpdateOwner(Owner(
                          id: widget.owner!.id,
                          name: _name,
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
}
