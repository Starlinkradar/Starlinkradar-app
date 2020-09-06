import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/tabs/oneStarlink.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../map.dart';
import 'package:flutter_app/utils.dart';

List globalData;

Future<List> getStarlinks() async {
  String apiURL = "https://spacex.moesalih.com/starlink/api";
  http.Response response = await http.get(apiURL);
  var entireData = json.decode(response.body);
  if (response.statusCode == 200) {
    return entireData;
  } else {
    throw ("Could not fetch starlinks");
  }
}

Future<List> dataFilter(input) async {
  var filteredData = [];
  globalData.forEach((element) {
    if (element["name"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase()) ||
        element["id"].toString().toLowerCase().contains(input.toLowerCase()) ||
        element["designator"]
            .toString()
            .toLowerCase()
            .contains(input.toLowerCase())) {
      //print(element);
      filteredData.add(element);
    }
  });
  return filteredData;
}

class Starlinks extends StatefulWidget {
  @override
  _StarlinksList createState() => _StarlinksList();
}

class _StarlinksList extends State<Starlinks> {
  Future<List> futureStarlinks;

  @override
  void initState() {
    super.initState();
    futureStarlinks = getStarlinks();
  }

  Icon search = Icon(Icons.search);
  Widget searchBar = Text("Starlinks");

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
                          futureStarlinks = dataFilter(input);
                        });
                      },
                    );
                  } else {
                    this.search = Icon(Icons.search);
                    this.searchBar = Text("Starlinks");

                    setState(() {
                      futureStarlinks = dataFilter("");
                    });
                  }
                });
              })
        ],
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: futureStarlinks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List _data = snapshot.data;
              if (firstTime == true) {
                globalData = _data;
                firstTime = false;
              }

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
                            title: _data[index]["name"] != null
                                ? Text(_data[index]["name"])
                                : Text("Undefined"),
                            subtitle: Text(
                                'Norad ID : ${_data[index]["id"]}\nDesignator/ID : ${_data[index]["designator"]}\nLaunch : ${_data[index]["launch"]}'),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              OutlineButton(
                                  child: const Text('Expand'),
                                  textColor: Colors.blue[500],
                                  //textColor:
                                  //    _data[index]["links"]["wikipedia"] != null
                                  //        ? Colors.blue[500]
                                  //        : Colors.grey[500],
                                  onPressed: () {
                                    yes(
                                      index,
                                    );
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OneStarlink()));
                                  }),
                              OutlineButton(
                                child: const Text('N2YO'),
                                textColor: Colors.blue[500],
                                //textColor:
                                //    _data[index]["links"]["wikipedia"] != null
                                //        ? Colors.blue[500]
                                //        : Colors.grey[500],
                                onPressed: () {
                                  openUrl(
                                      "https://www.n2yo.com/satellite/?s=${_data[index]["id"]}");
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
        label: Text("Map"),
        icon: Icon(Icons.map),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapPage())),
      ),
    );
  }
}
