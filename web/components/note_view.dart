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
    CustomEvent removeFromParentList = new CustomEvent('remove-from-list', detail: note.title);
    dispatchEvent(removeFromParentList);
  }
  
  void deleteNote(Event e, dynamic detail, Node target) {
    CustomEvent deleteNotePermanently = new CustomEvent('delete-from-database', detail: note.title);
    dispatchEvent(deleteNotePermanently);
  }
  
  NoteElement.created() : super.created() {
    this.draggable = true;
    
    _db.open().then((NotesStore store) {
      _store = store;
    });
  }
}