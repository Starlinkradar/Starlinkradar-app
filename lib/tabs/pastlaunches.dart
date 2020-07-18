import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'oneLaunch.dart';

Future<List> getAPIData() async {
  String apiURL = "https://api.spacexdata.com/v3/launches/past?order=desc";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData;
  } else {
    throw ("Could not fetch launches");
  }
}

class Launches extends StatefulWidget {
  @override
  _LaunchesList createState() => _LaunchesList();
}

class _LaunchesList extends State<Launches> {
  Future<List> futureLaunches;

  _launchURL(loll) async {
    var url = loll;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    futureLaunches = getAPIData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: futureLaunches,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _data = snapshot.data;
              return ListView.builder(
                  padding: EdgeInsets.all(2.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    String date() {
                      int timeInMillis = _data[index]["launch_date_unix"];
                      if (timeInMillis != null) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            timeInMillis * 1000);
                        return DateFormat.yMMMd().format(date); // Apr 8, 2020
                      } else {
                        return "Undefined";
                      }
                    }

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      color: Colors.grey[150],
                      elevation: 9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: _data[index]["links"]["mission_patch"] !=
                                    null
                                ? Image.network(
                                    "${_data[index]["links"]["mission_patch"]}")
                                : Icon(Icons.location_disabled),
                            title: Text(_data[index]["mission_name"]),
                            subtitle: Text(
                                'Flight Number : ${_data[index]["flight_number"]}\nRocket : ${_data[index]["rocket"]["rocket_name"]}\nLaunch Date : ${date()}'),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              OutlineButton(
                                  textColor: Colors.blue[500],
                                  child: const Text("Expand"),
                                  onPressed: () {
                                    OneLaunch().yes(index);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OneLaunch()));
                                  }),
                              _data[index]["links"]["wikipedia"] != null
                                  ? OutlineButton(
                                      child: const Text('Youtube'),
                                      textColor: _data[index]["links"]
                                                  ["wikipedia"] !=
                                              null
                                          ? Colors.blue[500]
                                          : Colors.grey[500],
                                      onPressed: () {
                                        if (_data[index]["links"]
                                                ["wikipedia"] !=
                                            null) {
                                          _launchURL(_data[index]["links"]
                                              ["video_link"]);
                                        }
                                      },
                                    )
                                  : FlatButton(
                                      child: const Text('Youtube'),
                                      textColor: _data[index]["links"]
                                                  ["wikipedia"] !=
                                              null
                                          ? Colors.blue[500]
                                          : Colors.grey[500],
                                      onPressed: () {
                                        if (_data[index]["links"]
                                                ["wikipedia"] !=
                                            null) {
                                          _launchURL(_data[index]["links"]
                                              ["video_link"]);
                                        }
                                      },
                                    ),
                              _data[index]["links"]["wikipedia"] != null
                                  ? OutlineButton(
                                      child: const Text('Wikipedia'),
                                      textColor: _data[index]["links"]
                                                  ["wikipedia"] !=
                                              null
                                          ? Colors.blue[500]
                                          : Colors.grey[500],
                                      onPressed: () {
                                        if (_data[index]["links"]
                                                ["wikipedia"] !=
                                            null) {
                                          _launchURL(_data[index]["links"]
                                              ["wikipedia"]);
                                        }
                                      },
                                    )
                                  : FlatButton(
                                      child: const Text('Wikipedia'),
                                      textColor: _data[index]["links"]
                                                  ["wikipedia"] !=
                                              null
                                          ? Colors.blue[500]
                                          : Colors.grey[500],
                                      onPressed: () {
                                        if (_data[index]["links"]
                                                ["wikipedia"] !=
                                            null) {
                                          _launchURL(_data[index]["links"]
                                              ["wikipedia"]);
                                        }
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
