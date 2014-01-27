library app;

import 'package:polymer/polymer.dart';

void main() {
  //initPolymer();
  
  try {
    print(1/0);
  } catch(e) {
    print(e.runtimeType);
  }
}