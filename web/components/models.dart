import 'compatible_json.dart' show CompatibleJson;
import 'package:polymer/polymer.dart';

class Json = Map<String, dynamic>;

class Note extends Object with Observable, CompatibleJson {
  @observable String title, content;
  @observable DateTime timeCreated;
  dynamic key;
  
  bool get notSaved => key == null;
  
  Note(this.title, this.content) {
    DateTime now = new DateTime.now();
    this.timeCreated = now;
  }
  
  Note.fromJson(Json json):
    title = json['title'],
    content = json['content'],
    timeCreated = DateTime.parse(json['timeCreated']) {}
  
  Note.fromRawKV(dynamic idbKey, Map<String, dynamic> value):
    title = value['title'],
    content = value['content'],
    timeCreated = DateTime.parse(value['timeCreated']),
    key = idbKey {}
   
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'timeCreated': timeCreated.toString()
    };
  }
  
  int titleCompare(Note note) {
    if (title != null) {
      return title.compareTo(note.title);
    }
  }
  
  int ageCompare(Note note) {
    if (timeCreated != null) {
      return timeCreated.compareTo(note.timeCreated);
    }
  }
  
  int sizeCompare(Note note) {
    if (content != null) {
      return content.length.compareTo(note.content.length);
    }
  }
  
  String toString() {
    return 'Note: ${title}';
  }
  
  void display() {
    print(this.toString());
  }
  
  Map<String, dynamic> get attributes => toJson();
  
  bool compatibleWithJson(Map<String, dynamic> json) {
    return(jsonCompatible(json));
  }
}