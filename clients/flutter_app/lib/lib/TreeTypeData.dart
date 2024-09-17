class TreeTypeData {
  late int id;
  late Map translations;

  TreeTypeData({
    required this.id,
    required this.translations
  });

  static TreeTypeData fromMap(Map decodedJson) {
    TreeTypeData data = TreeTypeData(
        id: decodedJson['id'],
        translations: decodedJson['translations'],
    );

    return data;
  }
}