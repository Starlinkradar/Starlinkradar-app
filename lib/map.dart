import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:http/http.dart' as http;

///var datamdr;
///
///Future<dynamic> fetchStarlinks() async {
///  var response = await http.get('https://trackstarlink.herokuapp.com/api/all');
///
///  if (response.statusCode == 200) {
///    // If the server did return a 200 OK response,
///    // then parse the JSON.
///    datamdr = json.decode(response.body);
///    return json.decode(response.body);
///  } else {
///    // If the server did not return a 200 OK response,
///    // then throw an exception.
///    throw Exception('Failed to load past launches');
///  }
///}

class _MapPageState extends State<MapPage> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  void loadData() async {
    // print(fetchStarlinks());
    print("Loading geojson data");
    var data = await http.get('https://trackstarlink.herokuapp.com/api/all');

    await statefulMapController.fromGeoJson(data.body,
        markerIcon: Icon(Icons.satellite), verbose: true);
  }

  @override
  void initState() {
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => loadData());
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    statefulMapController.switchTileLayer(TileLayerType.monochrome);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Starlinkradar"),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Stack(children: <Widget>[
          FlutterMap(
            mapController: mapController,
            options: MapOptions(center: LatLng(48.853831, 2.348722), zoom: 3.0),
            layers: [
              statefulMapController.tileLayer,
              MarkerLayerOptions(markers: statefulMapController.markers),
            ],
          ),
          //Positioned(
          //    top: 15.0,
          //    right: 15.0,
          //    child: TileLayersBar(controller: statefulMapController))
        ])));
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}
