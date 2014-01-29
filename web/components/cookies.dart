import 'dart:html';

class Person {
  String name;
  
  Person(this.name);
}

void createCookie(String name, String value) {
  document.cookie = '$name=$value';
}

Person personFromCookie(String cookie) {
  List<String> ca = document.cookie.split(';');
  ca.forEach((String s) {
    
  });
}
