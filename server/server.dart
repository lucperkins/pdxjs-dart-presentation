library server;

import 'dart:io';
import 'dart:convert';
import 'note_model.dart' show Json, Note;

const String HOST = 'localhost';
const int PORT = 3030;

void startServer(List<Note> notes) {
  HttpServer.bind(HOST, PORT).then((HttpServer server) {
    server.listen((HttpRequest req) {
      switch(req.method) {
        case 'GET':
          handleGet(req, notes);
          break;
        /* case 'POST':
          handlePost(req);
          break; */
        default: defaultHandler(req);
      }
    }, onError: printError);
  })
  .catchError(printError)
  .whenComplete(() => print('Listening for requests on port $PORT'));
}

void handleGet(HttpRequest req, List<Note> notes) {
  switch (req.uri.path){
    case '/notes':
      HttpResponse res = req.response;
      print('${req.method} : ${req.uri.path}');
      addCorsHeaders(res);
      res.headers.contentType = new ContentType('application', 'json', charset: 'utf-8');
      List<Map<String, dynamic>> notesAsJson = new List<Map<String, dynamic>>();
      notes.forEach((Note note) {
        Map<String, dynamic> noteAsJson = note.toJson();
        notesAsJson.add(noteAsJson);
      });
      Map<String, dynamic> finalJson = { 'notes': notesAsJson };
      res.write(JSON.encode(finalJson));
      res.close();
      break;
    default:
      defaultHandler(req);
      break;      
  }
}

void handlePost(HttpRequest req) {
  print('${req.method} : ${req.uri.path}');
  switch (req.uri.path) {
    case '/auth':
      req.listen((List<int> buffer) {
        HttpResponse res = req.response;
        String jsonString = new String.fromCharCodes(buffer);
        List<Map<String, dynamic>> jsonList = JSON.decode(jsonString);
        print('JSON list in POST: ${jsonList}');
        res.write('hello');
        res.close();
        // integrateDataFromClient(jsonList);
      });
      break;
  }

}

/* void integrateDataFromClient(List<Map<String, dynamic>> jsonList) {
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
} */

/*
void handleOptions(HttpRequest req) {
  print('${req.method}: ${req.uri.path}');
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}
*/

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
  List<Note> notes = [
                       new Note('things to buy at the store', 'eggs, bread, cream cheese'),
                       new Note('favorite movies of all time', 'Die Hard'),
                       new Note('albums to buy', 'Beatles, "Abbey Road"')
                     ];
  
  startServer(notes);
}