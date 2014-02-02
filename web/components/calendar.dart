import 'package:polymer/polymer.dart';
import 'day_element.dart' show Day;

@CustomTag('x-calendar-element')
class CalendarElement extends PolymerElement {
  // List<List<int>> thisMonth = createMonth(4);
  
  List<List<int>> createMonth(int start) {
    switch(start) {
      
    }
  }
  
  Day today = new Day(1, 30, 2014);
  
  bool get applyAuthorStyles => true;
  @observable String monthName = 'January';
  List<String> week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  
  List<List<int>> month = [week1, week2, week3, week4, week5];
  static List<int> week1 = [1,2,3,4,5,6,7];
  static List<int> week2 = [8,9,10,11,12,13,14];
  static List<int> week3 = [15,16,17,18,19,20,21];
  static List<int> week4 = [22,23,24,25,26,27,28];
  static List<int> week5 = [29, 30, 31];
  
  CalendarElement.created() : super.created() {
    
  }
}