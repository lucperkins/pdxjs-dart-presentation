part of data;

class Note extends Object with Comparable, Observable, CompatibleJson {
  @observable String title, content;
  @observable DateTime timeCreated;
  @observable DateTime timeUpdated;
  dynamic key;
  
  bool get notSaved => key == null;
  
  String get timeCreatedAsString =>
      """${timeCreated.hour}:${timeCreated.minute} on
      ${timeCreated.month}/${timeCreated.day}/${timeCreated.year}""";
  
  Note(this.title, this.content) {
    DateTime now = new DateTime.now();
    this.timeCreated = now;
  }
  
  Note.fromJson(Map<String, dynamic> json):
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
  
  @override
  int compareTo(Note other) {
    return title.compareTo(other.title);
  }
}