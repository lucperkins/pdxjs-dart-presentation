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
  final List<Note> notebook = new List<Note>();
  NotesStore(this.notesDb);
  
  Future<List<Note>> loadNotesFromDb() {
    Transaction trans = notesDb.db.transaction(NotesDb.NOTES_STORE, READ_ONLY);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    Stream<CursorWithValue> cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((CursorWithValue cursor) {
      Note note = new Note.fromRawKV(cursor.key, cursor.value);
      notebook.add(note);
    });
    return trans.completed.then((_) {
      return notebook;
    });
  }
  
  Future addNote(Note note) {
    Map<String, dynamic> noteJson = note.toJson();
    Transaction trans = notesDb.db.transaction(NotesDb.NOTES_STORE, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    store.add(noteJson);
    return trans.completed.then((dynamic addedKey) {
      Note note = new Note.fromRawKV(addedKey, noteJson);
      notebook.add(note);
    });
  }
  
  Future deleteNote(Note note) {
    print(note.key);
    Transaction trans = notesDb.db.transaction(NotesDb.NOTES_STORE, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    store.delete(note.key);
    return trans.completed;
  }
  
  Future deleteAll() {
    Transaction trans = notesDb.db.transaction(NotesDb.NOTES_STORE, READ_WRITE);
    ObjectStore store = trans.objectStore(NotesDb.NOTES_STORE);
    store.clear();
    return trans.completed;
  }
}