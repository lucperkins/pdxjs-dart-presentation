library app;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:route/client.dart';
import 'dart:html';

void main() {
  Logger.root.level = Level.INFO;
  Logger log = new Logger('main');
  
  
  initPolymer();
}


void serve() {
  String rootPath = window.location.pathname;
  
  final UrlPattern homeUrl = new UrlPattern(r'${rootPath}');
  final UrlPattern otherUrl = new UrlPattern(r'/other');
  
  final Router router = new Router(useFragment: true)
    ..addHandler(homeUrl, showHomePage)
    ..listen();  
}

void showHomePage(String path) {
  
}