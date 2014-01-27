import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('x-note-input')
class NoteInput extends InputElement with Polymer, Observable {
  void keyup(Event e, dynamic detail, Node target) {
    KeyEvent event = new KeyEvent.wrap(e);
    if (event.keyCode == KeyCode.ENTER) {
      dispatchEvent(new CustomEvent('note-submit-commit'));
    }
  }
  
  void keypress(Event e, dynamic detail, Node target) {
    KeyboardEvent event = new KeyEvent.wrap(e);
    if (event.keyCode == KeyCode.ESC) {
      dispatchEvent(new CustomEvent('note-submit-cancel'));
    }
  }
  
  NoteInput.created() : super.created();
}