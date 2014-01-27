library server;

import 'dart:io';
import 'dart:convert';
import '../web/components/models.dart' show Note;

const String HOST = 'localhost';
const int PORT = 3000;

List<Note> notes = [ new Note('stuff to remember', 'always be kind, no matter what'),
          new Note('The Wire notes', 'fourth season is the best, hands down'),
          new Note('Dart notes', 'study up on reified generics and abstract classes'),
          new Note('Friday to-do list', 'buy quinoa and kale for my stupid hipster dinner party')
        ];


class AuthInfo {
  String username;
  String password;
  AuthInfo(this.username, this.password);
}

AuthInfo luc = new AuthInfo('lucperkins', 'godaddysucks');
AuthInfo jesse = new AuthInfo('hallettj', 'haskellrules');

List<AuthInfo> authorizedUsers = [luc, jesse];


void startServer() {
  HttpServer.bind(HOST, PORT).then((HttpServer server) {
    server.listen((HttpRequest req) {
      switch(req.method) {
        case 'GET':
          handleGet(req);
          break;
        case 'POST':
          handlePost(req);
          break;
        default: defaultHandler(req);
      }
    }, onError: printError);
  })
  .catchError(printError)
  .whenComplete(() => print('Listening for requests on port $PORT'));
}

void handleGet(HttpRequest req) {
  HttpResponse res = req.response;
  print('${req.method} : ${req.uri.path}');
  addCorsHeaders(res);
  res.headers.contentType = new ContentType('application', 'json', charset: 'utf-8');
  List<Map<String, dynamic>> notesAsJsonList = new List<Map<String, dynamic>>();
  notes.forEach((Note note) {
    notesAsJsonList.add(note.toJson());
  });
  String jsonString = JSON.encode(notesAsJsonList);
  print('JSON list in GET request: ${notesAsJsonList}');
  res.write(jsonString);
  res.close();
}

void handlePost(HttpRequest req) {
  print('${req.method} : ${req.uri.path}');
  switch (req.uri.path) {
    case '/auth':
      req.listen((List<int> buffer) {
        String jsonString = new String.fromCharCodes(buffer);
        List<Map<String, dynamic>> jsonList = JSON.decode(jsonString);
        print('JSON list in POST: ${jsonList}');
        integrateDataFromClient(jsonList);
      });
      break;
  }

}

void integrateDataFromClient(List<Map<String, dynamic>> jsonList) {
  List<Note> clientNotes = new List<Note>();
  jsonList.forEach((Map map) {
    clientNotes.add(new Note.fromJson(map));
  });
  List<Note> serverNotes = notes;
  serverNotes.forEach((Note serverNote) {
    if (!clientNotes.contains(serverNote.title)) {
      serverNotes.remove(serverNote);
    }
  });
}

void handleOptions(HttpRequest req) {
  print('${req.method}: ${req.uri.path}');
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void defaultHandler(HttpRequest req) {
  print('${req.method}: ${req.uri.path}');
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void printError(SocketException e) {
  print(e.message);
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*, ');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}

void main() {
  startServer();
}