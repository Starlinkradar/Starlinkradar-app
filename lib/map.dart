import 'dart:collection';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import 'utils.dart';

Future<List> getStarlinks() async {
  String apiURL = "https://starlinkradar.herokuapp.com/api/all";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData["features"];
  } else {
    throw ("Could not fetch launches");
  }
}

class MapPage extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<MapPage> {
  Future<List> futureTrackStarlinks;

  BitmapDescriptor satIcon;

  Timer timer;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = HashSet<Marker>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.0, 2.0),
    zoom: 5.0,
  );

  void _setMapStyle(GoogleMapController controller) async {
    String style =
        await DefaultAssetBundle.of(context).loadString('assets/mapStyle.json');
    controller.setMapStyle(style);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setState(() {});
    _setMapStyle(controller);
  }

  @override
  void initState() {
    super.initState();
    futureTrackStarlinks = getStarlinks();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(32, 32)), 'assets/sat.png')
        .then((onValue) {
      satIcon = onValue;
    });
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      //_markers.clear();
      //sleep(Duration(seconds: 1));
      setState(() {
        futureTrackStarlinks = getStarlinks();
        //_markers = _markers;
      });
    });
  }

  void _showDialog(satName, satId, satDesignator, satVelocity, satHeight) {
    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Icon(Icons.satellite),
          SizedBox(
            height: 5,
          ),
          Text(
            satName,
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: futureTrackStarlinks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data.forEach((element) {
                try {
                  double lat = element["geometry"]["coordinates"][1];
                  double lng = element["geometry"]["coordinates"][0];
                  _markers.add(
                    Marker(
                        markerId: MarkerId(
                            element["properties"]["number"].toString()),
                        icon: satIcon,
                        onTap: () {},
                        position: LatLng(lat, lng)),
                  );
                } catch (err) {
                  print(err);
                }
              });

              return GoogleMap(
                initialCameraPosition: _kGooglePlex,
                onMapCreated: _onMapCreated,
                markers: _markers,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),*/
    );
  }
}
