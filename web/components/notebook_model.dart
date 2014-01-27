import 'dart:collection' show IterableMixin;
import 'models.dart' show Note;
import 'dart:convert';

class Notebook extends Object with IterableMixin<Note> {
  List<Note> notes = new List<Note>();
  Iterator<Note> get iterator => notes.iterator;
  int get length => notes.length;
  
  void sort() {
    notes.sort((Note thisOne, Note thatOne) {
      thisOne.compareTo(thatOne);
    });
  }
  
  bool contains(String title) {
    if (title != null) {
      notes.forEach((Note note) {
        if (note.title == title) {
          return true;
        }
      });
    }
    return false;
  }
  
  Note find(String title) {
    if (title != null) {
      notes.forEach((Note note) {
        if (note.title == title) {
          return note;
        }
      });
    }
  }
  
  bool add(Note note) {
    if (contains(note.title)) {
      return false;
    } else {
      notes.add(note);
      return true;
    }
  }
  
  bool remove(Note note) {
    return notes.remove(note);
  }
  
  void clear() => notes.clear();
  
  void display() {
    notes.forEach((Note note) {
      note.display();
    });
  }
  
  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
    notes.forEach((Note note) {
      list.add(note.toJson());
    });
    return list;
  }
  
  String toJsonString() {
    return JSON.encode(this.toJson());
  }
  
  Notebook(this.notes);
}