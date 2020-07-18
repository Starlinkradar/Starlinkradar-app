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
