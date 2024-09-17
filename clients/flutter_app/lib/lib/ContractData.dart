import 'ContractPreferencesData.dart';

class ContractData {
  late int id;
  late List<int> treeList;
  late String description;
  late ContractPreferencesData preferences;
  late List<String> roles;

  ContractData({
    required this.id,
    required this.treeList,
    required this.description,
    required this.preferences,
    required this.roles
  });

  static ContractData fromMap(Map rawData) {
    ContractPreferencesData jsonPreferences = ContractPreferencesData(
      advanced: rawData["advanced"] ?? false,
      language: rawData["language"] ?? 'latin'
    );

    ContractData data = ContractData(
      id: rawData['id'],
      treeList: List.from(rawData['treeList']),
      description: rawData['description'],
      preferences: jsonPreferences,
      roles: rawData['roles'] ?? [],
    );

    return data;
  }
}