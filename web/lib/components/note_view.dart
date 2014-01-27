import 'package:polymer/polymer.dart';
import 'dart:html';
import 'notebook_view.dart';

@CustomTag('x-note-view')
class NoteView extends LIElement with Polymer, Observable {
  @published Note note;
  
  bool get applyAuthorStyles => true;  
  
  NoteView.created() : super.created() { }
  
  
  /*
  void change(Event e, dynamic detail, Node target) {
    window.alert('something has changed');
  }
  
  void enteredView() {
    super.enteredView();
  }
  
  void leftView() {
    super.leftView();
  }
  
  void attributeChanged() {
    super.attributeChanged();
  } */
}