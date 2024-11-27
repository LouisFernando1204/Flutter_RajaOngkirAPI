import 'package:flutter_mvvm/data/network/network_api_services.dart';
import 'package:flutter_mvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/api/province');
      List<Province> result = [];
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/api/city');
      List<City> result = [];
      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }
      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provId) {
          selectedCities.add(c);
        }
      }
      return selectedCities;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Costs>> checkShipmentCost(
      String origin,
      String originType,
      String destination,
      String destinationType,
      int weight,
      String courier) async {
    try {
      print("Origin: ${origin}");
      print("Origin Type: ${originType}");
      print("Destination: ${destination}");
      print("Destination Type: ${destinationType}");
      print("Weight: ${weight}");
      print("Courier: ${courier}");

      dynamic response = await _apiServices.postApiResponse(
        '/api/cost',
        {
          "origin": origin,
          "originType": originType,
          "destination": destination,
          "destinationType": destinationType,
          "weight": weight,
          "courier": courier,
        },
      );
      if (response['rajaongkir']['status']['code'] != 200) {
        throw Exception(
            "Error: ${response['rajaongkir']['status']['description']}");
      }
      List<dynamic> results = response['rajaongkir']['results'];
      List<Costs> costs = results
          .expand((result) => (result['costs'] as List)
              .map((cost) => Costs.fromJson(cost as Map<String, dynamic>)))
          .toList();
      return costs;
    } catch (e) {
      throw e;
    }
  }
}
