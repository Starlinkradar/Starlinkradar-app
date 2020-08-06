// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/tabs/pastlaunches.dart';
import 'package:flutter_app/tabs/starlinks.dart';

import 'package:flutter/material.dart';
import 'tabs/about.dart';

import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

///import 'package:http/http.dart' as http;
///import 'dart:convert';

void main() => runApp(MyApp());

var brightness = SchedulerBinding.instance.window.platformBrightness;
bool darkModeOn = brightness == Brightness.dark;

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Starlinkradar';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      theme: darkModeOn ? ThemeData.dark() : ThemeData.light(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      {}
    } else {
      await prefs.setBool('seen', true);
      _showDialog();
    }
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          //Text("Join our Discord Server!"),
          Image.network(
            "https://vignette.wikia.nocookie.net/mining-simulator/images/d/dd/Discord.png/revision/latest/scale-to-width-down/340?cb=20191203134506",
            scale: 4.0,
          ),
          SizedBox(
            height: 15,
          ),
          OutlineButton.icon(
              onPressed: () => _launchURL("https://discord.gg/BHdGqAX"),
              icon: Icon(Icons.link),
              label: Text("Join our Discord Server!")),
          SizedBox(
            height: 15,
          ),
          Image.network(
            "https://i.imgur.com/0bCa8Oq.png",
            scale: 4.0,
          ),
          SizedBox(
            height: 15,
          ),
          OutlineButton.icon(
              onPressed: () => _launchURL("https://starlinkradar.com/"),
              icon: Icon(Icons.link),
              label: Text("Check out our website!")),
          SizedBox(
            height: 15,
          ),
          //Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

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
    new Future.delayed(Duration.zero, () {
      checkFirstSeen();
    });
  }

  Widget bottomNavigationCallPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return SafeArea(child: Launches());
      case 1:
        return SafeArea(child: Starlinks());
      case 2:
        return SafeArea(child: About());
        break;
      default:
        return SafeArea(child: About());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Starlinkradar'),
      //  centerTitle: true,
      //),
      body: bottomNavigationCallPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Launches'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.satellite),
            title: Text('Starlink'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('About'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[300],
        onTap: _onItemTapped,
      ),
    );
  }
}
