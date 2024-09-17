import 'dart:convert';

class UserData {
  late int id;
  late String email;
  late String firstName;
  late String lastName;
  late String? company;
  late String? website;
  late String type;
  late String? sector;
  late List<String> roles;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.website,
    required this.type,
    required this.sector,
    required this.roles
  });

  static Future<UserData> fromJSON(String json) async {
    var decodedJson = await jsonDecode(json);

    UserData data = UserData(
      id: decodedJson['id'],
      email: decodedJson['email'],
      firstName: decodedJson['firstName'],
      lastName: decodedJson['lastName'],
      company: decodedJson['company'],
      website: decodedJson['website'],
      type: decodedJson['type'],
      sector: decodedJson['sector'],
      // roles: decodedJson['roles'] as List<String>,
      roles: List.from(decodedJson['roles'])
    );

    return data;
  }
}