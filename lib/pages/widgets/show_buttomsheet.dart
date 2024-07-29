import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_laraflutter/bloc/owner/owner_bloc.dart';
import 'package:latihan_laraflutter/bloc/process_get_owner_bloc/process_get_owner_bloc.dart';

void showOwnerSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
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
                Expanded(
                  child: ListView.builder(
                    itemCount: state.owners.length,
                    itemBuilder: (context, index) {
                      final owner = state.owners[index];
                      final isSelected = context
                              .read<ProcessGetOwnerBloc>()
                              .state
                              .selectedOwner
                              ?.id ==
                          owner.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<ProcessGetOwnerBloc>()
                                .add(SelectOwner(owner));
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  owner.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
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
