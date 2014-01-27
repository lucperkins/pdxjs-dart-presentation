import 'package:polymer/polymer.dart';
import 'idb.dart' as idb;
import 'dart:html';

class Note {
  String title;
  String content;
  dynamic key;
  
  Note(this.title, this.content);
  
  Note.fromRawKV(this.key, Map<String, dynamic> value):
    title = value['title'],
    content = value['content'] {
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content
    };
  }
}

class Notebook {
  List<Note> notes;
  
  void add(Note note) {
    notes.add(note);
  }
  
  int get length => notes.length;
  
  Notebook(this.notes);
  
  void loadNotesFromDb() {
    idb.NotesDb db = new idb.NotesDb();
    idb.NotesStore store = new idb.NotesStore(db);
    store.loadNotesFromDb();
    /* store.loadNotesFromDb().then((List<Note> loadedNotes) {
      print('Loaded notes: ${loadedNotes.length}');
    }); */
  }
}

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  @observable List<Note> notebook = new Notebook(new List<Note>()).notes;
  @observable String title = 'test title';
  @observable String content = 'test content';
  
  void addNote(Event e, dynamic detail, Node target) {
    if (title.isNotEmpty && content.isNotEmpty) {
      Note note = new Note(title, content);
      print('note with the title $title added');
      print(notebook.length);
      notebook.add(note);
    }
  }
    
  NotebookElement.created() : super.created() {
    print('the notebook has been created');
    notebook.add(new Note('test', 'test'));
    // notebook.loadNotesFromDb();
  }
  
  void enteredView() {
    super.enteredView();
    print('the notebook has entered the view');
  }
}