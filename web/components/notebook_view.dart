import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'models.dart' show Note;
import 'idb.dart';

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  ObservableList<Note> notes = toObservable(new List<Note>());
  @observable String title = 'title';
  @observable String content = 'content';
  
  NotesDb _db = new NotesDb();
  NotesStore _store;
  
  void addNote(Event e, dynamic detail, Node target) {
    Note note = new Note(title, content);
    notes.add(note);
  }
  
  void clearNotes(Event e, dynamic detail, Node target) {
    notes.clear();
  }
  
  void saveNotes(Event e, dynamic detail, Node target) {
    notes.forEach((Note note) {
      _store.addNote(note);
    });
  }
  
  void deleteNotes(Event e, dynamic detail, Node target) {
    _store.deleteAll().then((_) {
      notes.clear();
    });
  }
  
  NotebookElement.created() : super.created() {
    _db.open().then((NotesStore store) {
      _store = store;      
      store.loadNotesFromDb().then((List<Note> loadedNotes) {
        loadedNotes.forEach((Note note) {
          notes.add(note);
        });
      });
    });
  }
}