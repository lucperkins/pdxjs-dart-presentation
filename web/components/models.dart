class Note {
  String title;
  String content;
  DateTime timeCreated;
  DateTime timeUpdated;
  bool updated;
  dynamic key;
  
  Note(this.title, this.content) {
    DateTime now = new DateTime.now();
    this.timeCreated = now;
    this.timeUpdated = now;
    this.updated = false;
  }
  
  void update() {
    updated = true;
    DateTime now = new DateTime.now();
    timeUpdated = now;
  }
  
  Note.fromJson(Map<String, dynamic> json):
    title = json['title'],
    content = json['content'],
    timeCreated = DateTime.parse(json['timeCreated']),
    timeUpdated = DateTime.parse(json['timeUpdated']),
    updated = json['updated'] {}
  
  Note.fromRawKV(dynamic key, Map<String, dynamic> value):
    title = value['title'],
    content = value['content'],
    timeCreated = DateTime.parse(value['timeCreated']),
    timeUpdated = DateTime.parse(value['timeUpdated']),
    updated = value['updated'] {}
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'timeCreated': timeCreated.toString(),
      'timeUpdated': timeUpdated.toString(),
      'updated': updated
    };
  }
  
  int compareTo(Note note) {
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
}