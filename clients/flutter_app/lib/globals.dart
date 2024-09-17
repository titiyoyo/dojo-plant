library globals;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'lib/ApiClient.dart';
import 'lib/ContractData.dart';
import 'lib/TreeTypeData.dart';
import 'lib/UserData.dart';

late CameraDescription camera;
late String? token;
late UserData userData;
late List<ContractData> contractsData;
late List<TreeTypeData> treeTypesData;
late ContractData currentContract;
late LocationPermission permission;

setGlobals() async {
  const storage = FlutterSecureStorage();
  token = await storage.read(key: 'token');

  if (token != null) {
    ApiClient client = ApiClient();
    http.Response userDataResponse = await client.get(dotenv.env['PATH_USER_DATA']);
    http.Response userContractsResponse = await client.get(dotenv.env['PATH_CONTRACTS_LIST']);

    userData = await UserData.fromJSON(userDataResponse.body.toString());
    contractsData = getContractsList(userContractsResponse.body.toString());
    currentContract = contractsData.first;

    http.Response treeTypesResponse = await client.get(dotenv.env['PATH_TREES_TYPES']);
    treeTypesData = getTreeTypesList(treeTypesResponse.body.toString());
  }
}

List<TreeTypeData> getTreeTypesList(String json) {
  var decodedJson = jsonDecode(json);
  List<dynamic> dataList = decodedJson.map(
    (row) => TreeTypeData.fromMap(row)
  ).toList();

  return dataList.cast<TreeTypeData>();
}

List<ContractData> getContractsList(String json) {
  var decodedJson = jsonDecode(json);
  List<dynamic> dataList = decodedJson.map(
    (row) => ContractData.fromMap(row)
  ).toList();

  return dataList.cast<ContractData>();
}