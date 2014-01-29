import 'package:polymer/polymer.dart';
import 'dart:html';

class AuthInfo {
  String username;
  String password;
  AuthInfo(this.username, this.password);
  
  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password
    };
  }
}

@CustomTag('x-auth-submit')
class AuthSubmitElement extends PolymerElement {
  @observable String username = 'username';
  @observable String password = 'password';
  static const String AUTH_URL = 'http://localhost:3000/auth';
  
  void authInfoSubmit(Event e, dynamic detail, Node target) {
    e.preventDefault();
    final AuthInfo authInfo = new AuthInfo(username, password);
    FormElement form = target as FormElement;
    Map<String, dynamic> data = authInfo.toMap();
    HttpRequest.postFormData(AUTH_URL,
        data,
        withCredentials: false,
        requestHeaders: {},
        onProgress: (Event e) => print(e)
    ).then((HttpRequest req) {
      print(req.responseType);
    });
  }
  
  
  AuthSubmitElement.created() : super.created();
}