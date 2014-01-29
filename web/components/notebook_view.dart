import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'models.dart' show Note;
import 'idb.dart';

@CustomTag('x-notebook-element')
class NotebookElement extends PolymerElement {
  MutationObserver observer;
    
  // We'll use an observable list for better DOM handling
  ObservableList<Note> notes = toObservable(new List<Note>());
  Note note;
  
  // These values are observable and thus synced directly with the DOM
  @observable String title;
  @observable String content;
  @observable String saveMessage = '';
  
  @observable bool get notEmpty => notes.isNotEmpty;
  
  bool get draggable => true;
  
  // We'll instantiate our DB accessor and declare an accessor for our note storage
  NotesDb _db = new NotesDb();
  NotesStore _store;
  
  // These Booleans determine whether a note can be added to the list
  bool get noteInputsNotEmpty => title.length > 0 && content.length > 0;
  bool get titleNotUsed => notes.every((Note note) => note.title != title);
  bool get titleLongEnough => title.length > 8;
  bool get savable => noteInputsNotEmpty && titleNotUsed && titleLongEnough;
  
  // Adds a note to the list but does not persist it
  void addNote(Event e, dynamic detail, Node target) {
    if (savable) {
      note = new Note(title.trim(), content.trim());
      notes.add(note);
      title = '';
      content = ''; 
    }
  }
   
  // Clears notes from the visible list, but does not delete them in IndexedDB
  void clearNotes(Event e, dynamic detail, Node target) {
    notes.clear();
  }
  
  // Saves all currently visible notes to IndexedDB
  // IndexedDB will refuse all duplicates, so the list will remain consistent
  void saveNotes(Event e, dynamic detail, Node target) {
    if (notes.isNotEmpty) {
      /* notes.forEach((Note note) {
        _store.addNote(note).then((_) => print('Saved!'));
      }); */
      _store.saveAll(notes);
    }
  }
  
  // This deletes all notes from IndexedDB
  void deleteNotes(Event e, dynamic detail, Node target) {
    _store.deleteAll().then((_) {
      notes.clear();
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
    String removeNoteTitle = e.detail;
    Note noteToRemove = notes.where((Note note) => note.title == removeNoteTitle).first;
    _store.deleteNote(noteToRemove).then((_) => notes.remove(noteToRemove));
    print(noteToRemove.key);
  }
  
  void sortByTitle() {
    notes.sort((Note a, Note b) {
      a.compare(b);
    });
  }
    
  // Just for fun
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
  
  // This is a necessary constructor for ALL Polymer elements. Here, we specify that whenever 
  // a NotebookElement is created, IndexedDB is opened, the NotesStore is accessed (or created if it
  // doesn't exist yet), and all notes there are fetched and placed into the DOM
  void _onMutation(List<MutationRecord> mutations, MutationObserver observer) {
    print('${mutations.length} mutations occurred, the first to ${mutations[0].target}');
  }
  
  NotebookElement.created() : super.created() {
    observer = new MutationObserver(_onMutation);    
    UListElement ul = shadowRoot.querySelector('ul');
    List<LIElement> lis = shadowRoot.querySelectorAll('li');
    observer
      ..observe(ul, childList: true);
      
    int _count = 0;
    
    _db.open().then((NotesStore store) {
      _store = store;      
      store.loadNotesFromDb().then((List<Note> loadedNotes) {
        loadedNotes.forEach((Note note) {
          notes.add(note);
        });
      });
    });
    
    /* new Timer.periodic(const Duration(seconds: 5), (t) {
      _count += 5;
      _store.saveAll(notes);
      print('saved at $_count seconds');
    });
  } */
  }
}