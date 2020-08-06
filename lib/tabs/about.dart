import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _Aboutme createState() => _Aboutme();
}

class _Aboutme extends State<About> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Icon(
            Icons.satellite,
            size: 75,
          ),
          Text(
            "\nHey! I'm Aymen, the developer of Starlinkradar!\n\nEverything I have created so far is 100% out of my own pocket so please consider supporting me to keep Starlinkradar up and free of advertisements!\n",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          OutlineButton(
            onPressed: () => _launchURL("https://ko-fi.com/aymen"),
            child: Text("Support me!"),
          ),
          OutlineButton(
            onPressed: () => _launchURL("https://discord.gg/BHdGqAX"),
            child: Text("Discord"),
          ),
          OutlineButton(
            onPressed: () => _launchURL("https://starlinkradar.com/"),
            child: Text("Website"),
          ),
        ],
      ),
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
    ));
  }
}
