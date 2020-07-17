import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../map.dart';

Future<List> getStarlinks() async {
  String apiURL = "https://trackstarlink.herokuapp.com/api/all";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData["features"];
  } else {
    throw ("Could not fetch starlinks");
  }
}

class Starlinks extends StatefulWidget {
  @override
  _StarlinksList createState() => _StarlinksList();
}

class _StarlinksList extends State<Starlinks> {
  Future<List> futureStarlinks;

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
    futureStarlinks = getStarlinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: futureStarlinks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _data = snapshot.data;
              return ListView.builder(
                  padding: EdgeInsets.all(2.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    //int timeInMillis = _data[index]["launch_date_unix"];
                    //var date = DateTime.fromMicrosecondsSinceEpoch(
                    //    timeInMillis * 1000000);
                    //var formattedDate =
                    //    DateFormat.yMMMd().format(date); // Apr 8, 2020
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
                            leading: Icon(Icons.satellite),
                            title: _data[index]["properties"]["name"] != null
                                ? Text(_data[index]["properties"]["name"])
                                : Text("Undefined"),
                            subtitle: Text(
                                'Norad ID : ${_data[index]["properties"]["id"]}\nDesignator/ID : ${_data[index]["properties"]["designator"]}\nLaunch : ${_data[index]["properties"]["launch"]}'),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              //FlatButton(
                              //  child: const Text('Youtube'),
                              //  textColor:
                              //      _data[index]["links"]["wikipedia"] != null
                              //          ? Colors.blue[500]
                              //          : Colors.grey[500],
                              //  onPressed: () {
                              //    if (_data[index]["links"]["wikipedia"] !=
                              //        null) {
                              //      _launchURL(
                              //          _data[index]["links"]["video_link"]);
                              //    }
                              //  },
                              //),
                              OutlineButton(
                                child: const Text('N2YO'),
                                //textColor:
                                //    _data[index]["links"]["wikipedia"] != null
                                //        ? Colors.blue[500]
                                //        : Colors.grey[500],
                                onPressed: () {
                                  _launchURL(
                                      "https://www.n2yo.com/satellite/?s=${_data[index]["properties"]["id"]}");
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Map (beta)"),
        icon: Icon(Icons.map),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPage())),
      ),
    );
  }
}
