import 'compatible_json.dart' show CompatibleJson;
import 'package:polymer/polymer.dart';

class Json = Map<String, dynamic>;

class Note extends Object with Observable, CompatibleJson {
  @observable String title, content;
  @observable DateTime timeCreated, timeUpdated;
  bool updated;
  dynamic key;
  bool saved;
  
  Note(this.title, this.content) {
    DateTime now = new DateTime.now();
    this.timeCreated = now;
    this.timeUpdated = now;
    this.updated = false;
    this.saved = false;
  }
  
  void update() {
    updated = true;
    DateTime now = new DateTime.now();
    timeUpdated = now;
  }
  
  Note strip() {
    title.trim();
    content.trim();
  }
  
  Note.fromJson(Json json):
    title = json['title'],
    content = json['content'],
    timeCreated = DateTime.parse(json['timeCreated']),
    timeUpdated = DateTime.parse(json['timeUpdated']),
    updated = json['updated'] {}
  
  Note.fromRawKV(dynamic idbKey, Map<String, dynamic> value):
    title = value['title'],
    content = value['content'],
    timeCreated = DateTime.parse(value['timeCreated']),
    timeUpdated = DateTime.parse(value['timeUpdated']),
    updated = value['updated'],
    key = idbKey {}
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'timeCreated': timeCreated.toString(),
      'timeUpdated': timeUpdated.toString(),
      'updated': updated,
      'key': key.toString()
    };
  }
  
  int compare(Note note) {
    if (title != null) {
      return title.compareTo(note.title);
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