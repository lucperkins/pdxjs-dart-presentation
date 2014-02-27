part of data;

class Application {
  Application();
  
  void init() {
    print('Starting application');
    initPolymer();
  }
  
  void deleteDB() {
    window.indexedDB.deleteDatabase('dart-note').then((_) {
      print('The database has been deleted');
    });
  }
}