import 'package:flutter/material.dart';
import 'package:flutter_mvvm/data/response/api_response.dart';
import 'package:flutter_mvvm/model/model.dart';
import 'package:flutter_mvvm/repository/home_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<List<Province>> provinceList = ApiResponse.loading();
  setProvinceList(ApiResponse<List<Province>> response) {
    provinceList = response;
    notifyListeners();
  }

  Future<dynamic> getProvinceList() async {
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityOriginList = ApiResponse.notStarted();
  setCityOriginList(ApiResponse<List<City>> response) {
    cityOriginList = response;
    notifyListeners();
  }

  Future<dynamic> getCityOriginList(var provId) async {
    _homeRepo.fetchCityList(provId).then((value) {
      setCityOriginList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityOriginList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> cityDestinationList = ApiResponse.notStarted();
  setCityDestinationList(ApiResponse<List<City>> response) {
    cityDestinationList = response;
    notifyListeners();
  }

  Future<dynamic> getCityDestinationList(var provId) async {
    _homeRepo.fetchCityList(provId).then((value) {
      setCityDestinationList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityDestinationList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<Costs>> costList = ApiResponse.loading();
  setCostList(ApiResponse<List<Costs>> response) {
    costList = response;
    notifyListeners();
  }

  bool isLoading = false;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<dynamic> checkShipmentCost(
      String origin,
      String originType,
      String destination,
      String destinationType,
      int weight,
      String courier) async {
    setLoading(true);
    _homeRepo
        .checkShipmentCost(
            origin, originType, destination, destinationType, weight, courier)
        .then((value) {
      setCostList(ApiResponse.completed(value));
      setLoading(false);
    }).onError((error, stackTrace) {
      setCostList(ApiResponse.error(error.toString()));
    });
  }
}
