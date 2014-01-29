import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'models.dart' show Note;
import 'idb.dart';

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  var notes = toObservable([]);
  @observable var title;
  @observable var content;
  
  //ObservableList<Note> notes = toObservable(new List<Note>());
  //@observable String title;
  //@observable String content;
  
  NotesDb _db = new NotesDb();
  NotesStore _store;
  
  bool get noteInputsNotEmpty => title.length > 0 && content.length > 0;
  bool get titleNotUsed => notes.every((Note note) => note.title != title);
  bool get titleLongEnough => title.length > 8;
  bool get savable => noteInputsNotEmpty && titleNotUsed && titleLongEnough;
  
  void addNote(Event e, dynamic detail, Node target) {
    if (savable) {
      Note note = new Note(title, content);
      notes.add(note);
      title = '';
      content = ''; 
    } else {
      print('awwww poop');
    }
  }
  
  void clearNotes(Event e, dynamic detail, Node target) {
    notes.clear();
  }
  
  void saveNotes(Event e, dynamic detail, Node target) {
    if (notes.isNotEmpty) {
      notes.forEach((Note note) {
        _store.addNote(note);
      });
    }
  }
  
  void deleteNotes(Event e, dynamic detail, Node target) {
    _store.deleteAll().then((_) {
      notes.clear();
    });
  }
  
  void removeByTitle(String title) {
    notes.removeWhere((Note note) => note.title == title);
  }
  
  void removeFromNotebook(CustomEvent e, dynamic detail, Node target) {
    String removeNoteTitle = e.detail;
    removeByTitle(removeNoteTitle);
    print(notes.length);
  }
  
  void deletePermanently(CustomEvent e, dynamic detail, Node target) {
    String removeNoteTitle = e.detail;
    Note noteToRemove = notes.where((Note note) => note.title == removeNoteTitle).first;
    _store.deleteNote(noteToRemove).then((_) => notes.remove(noteToRemove));
    print(noteToRemove.key);
  }
  
  void startCamera(Event e, dynamic detail, Node target) {
    window.navigator.getUserMedia(audio: false, video: true)
      .then((MediaStream videoStream) {
        VideoElement videoElement = new VideoElement()
          ..autoplay = true
          ..src = Url.createObjectUrlFromStream(videoStream)
          ..onLoadedMetadata.listen((Event e) => null);  
            
        this.replaceWith(videoElement);
         
        document.onClick.listen((Event e) {
          videoStream.stop();
        });
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