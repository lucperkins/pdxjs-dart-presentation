part of data;

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
  NotesDb notesDb;
  NotesStore(this.notesDb);
  
  // Some getters to make our lives easier
  String notesStore = NotesDb.NOTES_STORE;
  Transaction get readOnlyTransaction => notesDb.db.transaction(notesStore, READ_ONLY);
  Transaction get readWriteTransaction => notesDb.db.transaction(notesStore, READ_WRITE);
  ObjectStore get readOnlyStore => readOnlyTransaction.objectStore(notesStore);
  ObjectStore get readWriteStore => readWriteTransaction.objectStore(notesStore);
    
  // Load all notes stored on the DB
  Future<List<Note>> loadNotesFromDb() {
    List<Note> notes = new List<Note>();
    Transaction trans = readOnlyTransaction;
    ObjectStore store = readOnlyStore;
    Stream<CursorWithValue> notesStream = store.openCursor(autoAdvance: true).asBroadcastStream();
    notesStream.listen((CursorWithValue cursor) {
      Note note = new Note.fromRawKV(cursor.key, cursor.value);
      notes.add(note);
    });
    return trans.completed.then((_) {
      print('Number of notes: ${notes.length}');
      return notes;
    });
  }
  
  // Save each note in the current notebook
  void saveAll(List<Note> notesList) {
    notesList.forEach((Note note) {
      saveNote(note);
    });
  }
    
  // Save a specific note to IndexedDB
  void saveNote(Note note) {
    if (note.notSaved) {
      dynamic _key;
      Transaction trans = readWriteTransaction;
      ObjectStore store = readWriteTransaction.objectStore(notesStore);
      Map<String, dynamic> noteAsJson = note.toJson();
      store.put(noteAsJson).then((dynamic addedKey) {
        note.key = addedKey;
        _key = addedKey;
      });
      print('Note $_key has been saved');
    } else {
      print('Note already saved');
    }
  }
  
  // Delete specific note
  Future deleteNote(dynamic key) {
    Transaction trans = readWriteTransaction;
    ObjectStore store = readWriteTransaction.objectStore(notesStore);
    store.delete(key);
    return trans.completed.then((_) {
      print('Note $key has been successfully deleted');
    });
  }
  
  // Delete all notes
  Future deleteAll() {
    Transaction trans = readWriteTransaction;
    ObjectStore store = readWriteTransaction.objectStore(notesStore);
    store.clear();
    print('All notes have been deleted');
    return trans.completed;
  }
}