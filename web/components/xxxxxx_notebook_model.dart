import 'dart:collection' show IterableMixin;
import 'models.dart' show Note;
import 'dart:convert';

class Notebook {
  ObservableList<Note> notes = new List<Note>();
}