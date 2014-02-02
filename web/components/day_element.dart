import 'package:polymer/polymer.dart';
import 'dart:html';

class Day {
  int day;
  int month;
  int year;
  
  Day(this.day, this.month, this.year);
}

@CustomTag('x-day-element')
class DayElement extends TableSectionElement with Polymer, Observable {
  @published Day day;
  
  DayElement.created() : super.created() {
    window.alert('created!');
    
    this.onClick.listen((Event e) {
      this.style.backgroundColor = 'red';
    });
  }
}