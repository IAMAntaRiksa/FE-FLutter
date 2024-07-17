import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final String job;
  final int ownerId;

  Employee({
    required this.id,
    required this.name,
    required this.job,
    required this.ownerId,
  });

  @override
  List<Object> get props => [id, name, job, ownerId];

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      job: json['job'],
      ownerId: json['owner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'owner_id': ownerId,
    };
  }
}
