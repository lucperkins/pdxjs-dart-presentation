import 'package:polymer/polymer.dart';
import 'dart:html';
import 'models.dart' show Note;

@CustomTag('x-note-element')
class NoteElement extends LIElement with Polymer, Observable {
  @published Note note;
  
  bool get applyAuthorStyles => true;
  
  void discardNote(Event e, dynamic detail, Node target) {
    this.remove();
  }
  
  NoteElement.created() : super.created();
}