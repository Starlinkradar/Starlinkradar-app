import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//import 'starlinks.dart';
var index;

String yes(getter) {
  index = getter;
}

var i;
Future getStarlink() async {
  String apiURL = "https://spacex.moesalih.com/starlink/api";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData[index];
  } else {
    throw ("Could not fetch starlinks");
  }
}

class OneStarlink extends StatefulWidget {
  @override
  _OneStarlink createState() => _OneStarlink();
}

class _OneStarlink extends State<OneStarlink> {
  Future futureStarlink;

  @override
  void initState() {
    super.initState();
    futureStarlink = getStarlink();
  }

  static const optionsStyle =
      TextStyle(letterSpacing: 2, fontSize: 15, color: Colors.grey);
  static const optionsStyle1 =
      TextStyle(letterSpacing: 1, fontSize: 20, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starlinkradar"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: FutureBuilder(
            future: futureStarlink,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Name",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data["name"],
                        style: optionsStyle1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "ID | Designator",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${snapshot.data["id"]} | ${snapshot.data["designator"]}",
                        style: optionsStyle1,
                      ),
                      /*SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Launch",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${snapshot.data["launch"]}",
                        style: optionsStyle1,
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Live",
                        style: TextStyle(
                            fontSize: 35, color: Colors.deepOrange[200]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Velocity",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data["info"]["velocity"].toString(),
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrange[170]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Position (latlng)",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Latitude : ${snapshot.data["info"]["lat"]}\nLongitude : ${snapshot.data["info"]["lng"]}",
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrange[170]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Height (km)",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data["info"]["height"].toString(),
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrange[170]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Azimuth",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data["info"]["azimuth"].toString(),
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrange[170]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Range",
                        style: optionsStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data["info"]["range"].toString(),
                        style: TextStyle(
                            fontSize: 15, color: Colors.deepOrange[170]),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Refresh"),
        icon: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            futureStarlink = getStarlink();
            //return Center(child: CircularProgressIndicator());
          });
        },
      ),
    );
  }
}
