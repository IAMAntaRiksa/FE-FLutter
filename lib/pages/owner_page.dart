import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/owner/owner_bloc.dart';
import '../models/owner.dart';
import 'owner_form_page.dart';

class OwnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owners'),
      ),
      body: BlocBuilder<OwnerBloc, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is OwnerLoaded) {
            return ListView.builder(
              itemCount: state.owners.length,
              itemBuilder: (context, index) {
                final owner = state.owners[index];
                return ListTile(
                  title: Text(owner.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<OwnerBloc>(context)
                          .add(DeleteOwner(owner.id));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OwnerFormPage(owner: owner),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is OwnerError) {
            return Center(child: Text('Failed to load owners'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OwnerFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
