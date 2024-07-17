import 'package:equatable/equatable.dart';

class Owner extends Equatable {
  final int id;
  final String name;

  Owner({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [id, name];

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
