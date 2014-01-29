library app;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

void main() {  
  Logger.root.level = Level.FINEST;
  Logger log = new Logger('main');
  
  initPolymer();
}