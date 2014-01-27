import 'package:polymer/polymer.dart';
import 'dart:html';
import 'models.dart' show Note;
import 'idb.dart';

@CustomTag('x-note-element')
class NoteElement extends LIElement with Polymer, Observable {
  @published Note note;
  
  NotesDb _db = new NotesDb();
  NotesStore _store;
  
  bool get applyAuthorStyles => true;
  
  void discardNote(Event e, dynamic detail, Node target) {
    this.remove();
  }
  
  NoteElement.created() : super.created() {
    _db.open().then((NotesStore store) {
      _store = store;
    });
    this.draggable = true;
  }

  void enteredView() {
    
  }
}