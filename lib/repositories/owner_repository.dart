import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/owner.dart';

class OwnerRepository {
  final String apiUrl = "https://3580-114-10-98-190.ngrok-free.app/api/owners";

  Future<List<Owner>> getOwners() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Owner.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load owners');
    }
  }

  Future<Owner> createOwner(Owner owner) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(owner.toJson()),
    );

    if (response.statusCode == 201) {
      return Owner.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create owner');
    }
  }

  Future<Owner> updateOwner(Owner owner) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${owner.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(owner.toJson()),
    );

    if (response.statusCode == 200) {
      return Owner.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update owner');
    }
  }

  Future<void> deleteOwner(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete owner');
    }
  }
}
