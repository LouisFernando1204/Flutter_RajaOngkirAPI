part of 'pages.dart';

class CostPage extends StatefulWidget {
  const CostPage({super.key});

  @override
  State<CostPage> createState() => _CostPageState();
}

class _CostPageState extends State<CostPage> {
  HomeViewModel homeViewModel = HomeViewModel();

  final ctrlWeight = TextEditingController();

  bool isLoading = false;

  final List<String> courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];
  String selectedCourier = "jne";

  dynamic selectedProvinceOrigin;
  dynamic selectedCityOrigin;

  dynamic selectedProvinceDestination;
  dynamic selectedCityDestination;

  static Container LoadingBlock() {
    return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: Colors.black26,
        child: SpinKitFadingCircle(size: 50, color: Colors.blueAccent));
  }

  @override
  void initState() {
    homeViewModel.getProvinceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Text(
                style: TextStyle(color: Colors.white), "Hitung Ongkir"),
            centerTitle: true),
        body: ChangeNotifierProvider<HomeViewModel>(
          create: (context) => homeViewModel,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(children: [
                      Flexible(
                          flex: 1,
                          child: Card(
                              color: Colors.white,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: selectedCourier,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 2,
                                              hint: Text('Pilih Layanan Kurir'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                              items: courierOptions.map<
                                                      DropdownMenuItem<String>>(
                                                  (String courier) {
                                                return DropdownMenuItem<String>(
                                                  value: courier,
                                                  child: Text(
                                                      courier.toUpperCase()),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedCourier =
                                                      newValue ?? "jne";
                                                });
                                                print(
                                                    'Kurir: $selectedCourier');
                                              },
                                            )),
                                        SizedBox(width: 18),
                                        Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: ctrlWeight,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  labelText: 'Berat (gr)'),
                                              onChanged: (newValue) {
                                                print(
                                                    'Berat: ${ctrlWeight.text}');
                                              },
                                            ))
                                      ]),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Origin",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Consumer<HomeViewModel>(
                                                builder: (context, value, _) {
                                              switch (
                                                  value.provinceList.status) {
                                                case Status.loading:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .blueAccent));
                                                case Status.error:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(value
                                                          .provinceList.message
                                                          .toString()));
                                                case Status.completed:
                                                  return DropdownButton(
                                                    isExpanded: true,
                                                    value:
                                                        selectedProvinceOrigin,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 2,
                                                    hint:
                                                        Text('Pilih provinsi'),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    items: value
                                                        .provinceList.data!
                                                        .map<
                                                                DropdownMenuItem<
                                                                    Province>>(
                                                            (Province value) {
                                                      return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .province
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedProvinceOrigin =
                                                            newValue;
                                                        selectedCityOrigin =
                                                            null;
                                                      });
                                                      if (newValue != null) {
                                                        value.setCityOriginList(
                                                            ApiResponse
                                                                .loading());
                                                        homeViewModel
                                                            .getCityOriginList(
                                                                selectedProvinceOrigin
                                                                    .provinceId);
                                                      }
                                                      print(
                                                          'Province Origin: $selectedProvinceOrigin');
                                                    },
                                                  );
                                                default:
                                                  return Container();
                                              }
                                            })),
                                        SizedBox(width: 18),
                                        Expanded(
                                            flex: 1,
                                            child: Consumer<HomeViewModel>(
                                                builder: (context, value, _) {
                                              switch (
                                                  value.cityOriginList.status) {
                                                case Status.notStarted:
                                                  return DropdownButton(
                                                    isExpanded: true,
                                                    value: selectedCityOrigin,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 2,
                                                    hint: Text('Pilih kota'),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: value,
                                                        child: Text(
                                                            "Provinsi belum dipilih"),
                                                      )
                                                    ],
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedCityOrigin =
                                                            newValue;
                                                      });
                                                    },
                                                  );
                                                case Status.loading:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Colors.blueAccent,
                                                      ));
                                                case Status.error:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(value
                                                          .cityOriginList
                                                          .message
                                                          .toString()));
                                                case Status.completed:
                                                  if (value.cityOriginList
                                                              .data !=
                                                          null &&
                                                      value.cityOriginList.data!
                                                          .isNotEmpty) {
                                                    return DropdownButton(
                                                      isExpanded: true,
                                                      value: selectedCityOrigin,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 2,
                                                      hint: Text('Pilih kota'),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      items: value
                                                          .cityOriginList.data!
                                                          .map<
                                                              DropdownMenuItem<
                                                                  City>>((City
                                                              value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .cityName
                                                              .toString()),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedCityOrigin =
                                                              newValue;
                                                        });
                                                        print(
                                                            'City Origin: $selectedCityOrigin');
                                                      },
                                                    );
                                                  } else {
                                                    return Text(
                                                        "Tidak ada kota tersedia.");
                                                  }
                                                default:
                                                  return Container();
                                              }
                                            }))
                                      ]),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Consumer<HomeViewModel>(
                                                builder: (context, value, _) {
                                              switch (
                                                  value.provinceList.status) {
                                                case Status.loading:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: Colors
                                                                  .blueAccent));
                                                case Status.error:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(value
                                                          .provinceList.message
                                                          .toString()));
                                                case Status.completed:
                                                  return DropdownButton(
                                                    isExpanded: true,
                                                    value:
                                                        selectedProvinceDestination,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 2,
                                                    hint:
                                                        Text('Pilih provinsi'),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    items: value
                                                        .provinceList.data!
                                                        .map<
                                                                DropdownMenuItem<
                                                                    Province>>(
                                                            (Province value) {
                                                      return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .province
                                                              .toString()));
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedProvinceDestination =
                                                            newValue;
                                                        selectedCityDestination =
                                                            null;
                                                      });
                                                      if (newValue != null) {
                                                        value
                                                            .setCityDestinationList(
                                                                ApiResponse
                                                                    .loading());
                                                        homeViewModel
                                                            .getCityDestinationList(
                                                                selectedProvinceDestination
                                                                    .provinceId);
                                                      }
                                                      print(
                                                          'Province Destination: $selectedProvinceDestination');
                                                    },
                                                  );
                                                default:
                                                  return Container();
                                              }
                                            })),
                                        SizedBox(width: 18),
                                        Expanded(
                                            flex: 1,
                                            child: Consumer<HomeViewModel>(
                                                builder: (context, value, _) {
                                              switch (value
                                                  .cityDestinationList.status) {
                                                case Status.notStarted:
                                                  return DropdownButton(
                                                    isExpanded: true,
                                                    value:
                                                        selectedCityDestination,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 2,
                                                    hint: Text('Pilih kota'),
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    items: [
                                                      DropdownMenuItem(
                                                        value: value,
                                                        child: Text(
                                                            "Provinsi belum dipilih"),
                                                      )
                                                    ],
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedCityDestination =
                                                            newValue;
                                                      });
                                                    },
                                                  );
                                                case Status.loading:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            Colors.blueAccent,
                                                      ));
                                                case Status.error:
                                                  return Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(value
                                                          .cityDestinationList
                                                          .message
                                                          .toString()));
                                                case Status.completed:
                                                  if (value.cityDestinationList
                                                              .data !=
                                                          null &&
                                                      value.cityDestinationList
                                                          .data!.isNotEmpty) {
                                                    return DropdownButton(
                                                      isExpanded: true,
                                                      value:
                                                          selectedCityDestination,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 2,
                                                      hint: Text('Pilih kota'),
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      items: value
                                                          .cityDestinationList
                                                          .data!
                                                          .map<
                                                              DropdownMenuItem<
                                                                  City>>((City
                                                              value) {
                                                        return DropdownMenuItem(
                                                          value: value,
                                                          child: Text(value
                                                              .cityName
                                                              .toString()),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedCityDestination =
                                                              newValue;
                                                        });
                                                        print(
                                                            'City Destination: $selectedCityDestination');
                                                      },
                                                    );
                                                  } else {
                                                    return Text(
                                                        "Tidak ada kota tersedia.");
                                                  }
                                                default:
                                                  return Container();
                                              }
                                            }))
                                      ]),
                                  SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (selectedCityOrigin != null &&
                                            selectedCityDestination != null &&
                                            ctrlWeight.text != "" &&
                                            selectedCourier != "") {
                                          homeViewModel
                                              .checkShipmentCost(
                                                  selectedCityOrigin.cityId
                                                      .toString(),
                                                  "city",
                                                  selectedCityDestination.cityId
                                                      .toString(),
                                                  "city",
                                                  int.parse(ctrlWeight.text),
                                                  selectedCourier)
                                              .then((onValue) {
                                            print(
                                                'City Origin: ${selectedCityOrigin.cityName.toString()}');
                                            print(
                                                'City Destination: ${selectedCityDestination.cityName.toString()}');
                                            print(
                                                'Weight: ${int.parse(ctrlWeight.text)}');
                                            print('Courier: $selectedCourier');
                                            print('Cost List: $onValue');
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        elevation: 0,
                                        padding:
                                            EdgeInsets.fromLTRB(32, 16, 32, 16),
                                      ),
                                      child: Text(
                                        "Hitung Estimasi Harga",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ]),
                              ))),
                      Flexible(
                        flex: 1,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Consumer<HomeViewModel>(
                              builder: (context, value, _) {
                            switch (value.costList.status) {
                              case Status.loading:
                                return Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Tidak ada data.",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ));
                              case Status.error:
                                return Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        value.costList.message.toString()));
                              case Status.completed:
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (isLoading) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                });
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: ListView.builder(
                                      itemCount: value.costList.data?.length,
                                      itemBuilder: (context, index) {
                                        return CardCost(value.costList.data!
                                            .elementAt(index));
                                      }),
                                );
                              default:
                                return Container();
                            }
                          }),
                        ),
                      )
                    ])),
              ),
              Consumer<HomeViewModel>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return Container(
                      color: Colors.black26,
                      child: Center(
                        child: LoadingBlock(),
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ));
  }
}
