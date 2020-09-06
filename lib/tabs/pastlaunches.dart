import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'oneLaunch.dart';
import '../utils.dart';

List globalData;

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

Future<List> dataFilter(input) async {
  var filteredData = [];
  globalData.forEach((element) {
    if (element["mission_name"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()) ||
        element["flight_number"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()) ||
        element["rocket"]["rocket_name"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()) ||
        date(element["launch_date_unix"]).toLowerCase().contains(input)) {
      //print(element);
      filteredData.add(element);
    }
  });
  return filteredData;
}

class Launches extends StatefulWidget {
  @override
  _LaunchesList createState() => _LaunchesList();
}

class _LaunchesList extends State<Launches> {
  Future<List> futureLaunches;

  @override
  void initState() {
    super.initState();
    futureLaunches = getAPIData();
  }

  Widget searchBar = Text("Launches");
  Icon search = Icon(Icons.search);

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
              icon: search,
              onPressed: () {
                setState(() {
                  if (this.search.icon == Icons.search) {
                    this.search = Icon(Icons.cancel);
                    this.searchBar = TextField(
                      textInputAction: TextInputAction.done,
                      onChanged: (input) {
                        setState(() {
                          futureLaunches = dataFilter(input);
                        });
                      },
                    );
                  } else {
                    this.search = Icon(Icons.search);
                    this.searchBar = Text("Launches");

                    setState(() {
                      futureLaunches = dataFilter("");
                    });
                  }
                });
              })
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: futureLaunches,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _data = snapshot.data;
              if (firstTime) {
                globalData = _data;
                firstTime = false;
              }
              return ListView.builder(
                  padding: EdgeInsets.all(2.0),
                  itemCount: _data.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                'Flight Number : ${_data[index]["flight_number"]}\nRocket : ${_data[index]["rocket"]["rocket_name"]}\nLaunch Date : ${date(_data[index]["launch_date_unix"])}'),
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
                                          openUrl(_data[index]["links"]
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
                                          openUrl(_data[index]["links"]
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
                                          openUrl(_data[index]["links"]
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
                                          openUrl(_data[index]["links"]
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
