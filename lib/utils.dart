import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

openUrl(_url) async {
  var url = _url;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String date(unix) {
  int timeInMillis = unix;
  if (timeInMillis != null) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);
    return DateFormat.yMMMd().format(date); // Apr 8, 2020
  } else {
    return "Undefined";
  }
}
