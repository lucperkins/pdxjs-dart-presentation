library app;

import 'dart:html';
import '../lib/data.dart';

void main() {
  Application app = new Application();
  app.init();
  Element header = querySelector('h3');
  header.text = 'foo';
  header.className = 'bar';
  header..text = 'foo'..className = 'bar';
}