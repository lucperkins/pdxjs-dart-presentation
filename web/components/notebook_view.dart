import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../lib/data.dart' show Note, NotesDb, NotesStore;

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  MutationObserver _observer;
    
  // We'll use an observable list for better DOM handling
  ObservableList<Note> notes = toObservable(new List<Note>());
  
  // These values are observable and thus synced directly with the DOM
  @observable String title;
  @observable String content;
  @observable String saveMessage = '';
  
  @observable bool get notEmpty => notes.isNotEmpty;
  
  bool get draggable => true;
  bool get applyAuthorStyles => true;
  
  // We'll instantiate our DB accessor and declare an accessor for our note storage
  NotesDb _db = new NotesDb();
  NotesStore _store;
  
  // These Booleans determine whether a note can be added to the list
  bool get thereAreNotes => notes.length > 0;
  bool get noteInputsNotEmpty => title.length > 0 && content.length > 0;
  bool get titleNotUsed => notes.every((Note note) => note.title != title);
  bool get titleLongEnough => title.length > 1;
  bool get savable => noteInputsNotEmpty && titleNotUsed && titleLongEnough;
  
  // Adds a note to the list but does not persist it
  void addNote(Event e, dynamic detail, Node target) {
    if (savable) {
      Note note = new Note(title, content);
      notes.add(note);
      title = '';
      content = '';
    }
  }
   
  // Clears notes from the visible list, but does not delete them in IndexedDB
  void clearNotes(Event e, dynamic detail, Node target) {
    if (thereAreNotes) {
      notes.clear();
      print('Notes have been cleared from the list'); 
    }
  }
  
  // Saves all currently visible notes to IndexedDB
  // IndexedDB will refuse all duplicates, so the list will remain consistent
  void saveNotes() {
    _store.saveAll(notes);
    /* _store.saveAll(notes).then((_) {
      print('ok');
    }); */
  }
  
  void displayError(Event e) {
    print(e);
  }
  
  // This deletes all notes from IndexedDB
  void deleteNotes(Event e, dynamic detail, Node target) {
    _store.deleteAll().then((_) {
      notes.clear();
      print('Notes have been cleared');
    });
  }
  
  // Removes a specific note on the basis of its title
  // No duplicate titles are allowed, so this operation is safe
  void removeByTitle(String title) {
    notes.removeWhere((Note note) => note.title == title);
  }
  
  // This will remove a specific note from the visible list, on the basis of information 
  // passed by the custom event fired from x-note-element (but it won't delete it)
  void removeFromNotebook(CustomEvent e, dynamic detail, Node target) {
    String removeNoteTitle = e.detail;
    removeByTitle(removeNoteTitle);
    print(notes.length);
  }
  
  // This will delete a specific note from IndexedDB
  void deletePermanently(CustomEvent e, dynamic detail, Node target) {
    String title = detail;
    Note noteToDelete = notes.where((Note note) => note.title == title).first;
    dynamic key = noteToDelete.key;
    _store.deleteNote(key).then((_) {
      notes.remove(noteToDelete);
    });
  }
  
  void sortByTitle() {
    notes.sort((Note a, Note b) => a.titleCompare(b));
  }
  
  void sortByDate() {
    notes.sort((Note a, Note b) => a.ageCompare(b));
  }
  
  void sortBySize() {
    notes.sort((Note a, Note b) => a.sizeCompare(b));
  }
    
  @override
  void enteredView() {
    int _count = 0;
    
    new Timer.periodic(const Duration(seconds: 5), (_) {
      print('${notes.length} saved at ${_count} seconds');
      _count += 5;
      saveNotes();
    });
  }
  
  // This is a necessary constructor for ALL Polymer elements. Here, we specify that whenever 
  // a NotebookElement is created, IndexedDB is opened, the NotesStore is accessed (or created if it
  // doesn't exist yet), and all notes there are fetched and placed into the DOM
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