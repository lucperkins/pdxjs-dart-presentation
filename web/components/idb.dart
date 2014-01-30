library idb;

import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';
import 'models.dart' show Note;
// import 'compatible_json.dart' show CompatibleWithJson;

class NotesDb {
  static const String NOTES_STORE = 'notesStore';
  static const String TITLE_INDEX = 'titleIndex';
  static const int version = 1;
  
  Database _db;
  Database get db => _db;
  NotesStore _notesStore;
  NotesStore get notesStore => _notesStore;
  
  Future open() {
    return window.indexedDB
        .open('dart-note', version: version, onUpgradeNeeded: _initDb)
        .then(_loadDb);
  }
  
  void _initDb(VersionChangeEvent e) {
    Database db = (e.target as Request).result;
    ObjectStore store = db.createObjectStore(NOTES_STORE, autoIncrement: true);
    store.createIndex(TITLE_INDEX, 'title', unique: true);
  }
  
  NotesStore _loadDb(Database db) {
    _db = db;
    _notesStore = new NotesStore(this);
    return _notesStore;
  }
}

class NotesStore {
  static const String READ_ONLY = 'readonly';
  static const String READ_WRITE = 'readwrite';
  final NotesDb notesDb;
  final List<Note> _notes = new List<Note>();
  NotesStore(this.notesDb);
  
  String notesStore = NotesDb.NOTES_STORE;
  /* Transaction get readOnlyTransaction => notesDb.db.transaction(notesStore, READ_ONLY);
  Transaction get readWriteTransaction => notesDb.db.transaction(notesStore, READ_WRITE);
  ObjectStore get readOnlyStore => readOnlyTransaction.objectStore(notesStore);
  ObjectStore get readWriteStore => readWriteTransaction.objectStore(notesStore); */
  
  Future<List<Note>> loadNotesFromDb() {
    Transaction trans = notesDb.db.transaction(notesStore, READ_ONLY);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    Stream<CursorWithValue> cursor = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursor.listen((CursorWithValue cursor) {
      Note note = new Note.fromRawKV(cursor.key, cursor.value);
      _notes.add(note);
    });
    return trans.completed.then((_) {
      return _notes;
    });
  }
  
  Future saveAll(List<Note> notesList) {
    notesList.forEach((Note note) {
      saveNote(note);
    });
  }
  
  Future<Note> findByTitle(String title) {
    Transaction trans = notesDb.db.transaction(notesStore, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    Index index = store.index(NotesDb.TITLE_INDEX);
    Future future = index.get(title);
    return future
      .then((Map<String, dynamic> noteJson) {
        Note note = new Note.fromJson(noteJson);
        return note;
      });
  }
  
  Future saveNote(Note note) {
    if (note.notSaved) {
      Transaction trans = notesDb.db.transaction(notesStore, READ_WRITE);
      ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
      Map<String, dynamic> noteAsJson = note.toJson();
      store.put(noteAsJson).then((dynamic addedKey) {
        note.key = addedKey;
      });
      return trans.completed.then((_) {
        print('Notes have been saved');
      });
    } else {
      print('Key is not null');
    }
  }
  
  Future deleteNote(dynamic key) {
    Transaction trans = notesDb.db.transaction(notesStore, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    store.delete(key);
    return trans.completed.then((_) {
      print('Note has been successfully deleted');
    });
  }
  
  Future deleteAll() {
    Transaction trans = notesDb.db.transaction(notesStore, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    store.clear();
    return trans.completed;
  }
}