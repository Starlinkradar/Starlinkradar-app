import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

//import 'starlinks.dart';
var index;

Future getLaunch() async {
  String apiURL = "https://api.spacexdata.com/v3/launches/past?order=desc";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData[index];
  } else {
    throw ("Could not fetch launch");
  }
}

class OneLaunch extends StatefulWidget {
  String yes(getter) {
    index = getter;
  }

  @override
  _OneLaunch createState() => _OneLaunch();
}

class _OneLaunch extends State<OneLaunch> {
  Future futureLaunch;

  @override
  void initState() {
    super.initState();
    futureLaunch = getLaunch();
  }

  static const optionsStyle =
      TextStyle(letterSpacing: 2, fontSize: 10, color: Colors.grey);
  static const optionsStyle1 =
      TextStyle(letterSpacing: 1, fontSize: 15, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Starlinkradar"),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: FutureBuilder(
            future: futureLaunch,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                int timeInMillis = snapshot.data["launch_date_unix"];

                var timestamp =
                    DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);
                var date = DateFormat.yMMMd().add_jm().format(timestamp);

                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Mission | Flight",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20)),
                              SizedBox(
                                width: 20,
                              ),
                              Image.network(
                                snapshot.data["links"]["mission_patch_small"],
                                height: 50,
                              )
                            ],
                          ),
                          Text(
                            snapshot.data["launch_success"]
                                ? "Successful Launch"
                                : "Failed Launch",
                            style: snapshot.data["launch_success"]
                                ? TextStyle(color: Colors.green, fontSize: 10)
                                : TextStyle(color: Colors.red, fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Details",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["details"],
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Mission name",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["mission_name"],
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Flight number",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["flight_number"].toString(),
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Launch date",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            date,
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Launch site",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["launch_site"]["site_name_long"],
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Launch window",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["launch_window"].toString(),
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Rocket",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Name",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["rocket"]["rocket_name"],
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "ID",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["rocket"]["rocket_id"],
                            style: optionsStyle1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Type",
                            style: optionsStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data["rocket"]["rocket_type"],
                            style: optionsStyle1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
