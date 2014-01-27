import 'dart:html';
import 'package:polymer/polymer.dart';
import 'models.dart' show Note;
// import 'idb.dart';

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  ObservableList<Note> notes = toObservable(new List<Note>());
  @observable String title = 'title';
  @observable String content = 'content';
  
  void addNote(Event e, dynamic detail, Node target) {
    Note note = new Note(title, content);
    notes.add(note);
    print(this.children);
  }
  
  void clearNotes(Event e, dynamic detail, Node target) {
    notes.clear();
  }
  
  void saveNotes(Event e, dynamic detail, Node target) {
    // notes.saveToDb().then((_) => window.alert('Your notes have been saved!'));
    print('saved!');
  }
   
  NotebookElement.created() : super.created() {
    print(this.childNodes);
  }
}