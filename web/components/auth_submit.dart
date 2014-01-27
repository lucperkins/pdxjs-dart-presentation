import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('x-auth-submit')
class AuthSubmitElement extends PolymerElement {
  @observable String username = 'username';
  @observable String password = 'password';
  
  void submit(Event e, dynamic detail, Node target) {
    HttpRequest.postFormData('/auth', data, withCredentials: asdf, responseType: asdf, requestHeaders: asdf, onProgress: asdf)
  }
  
  AuthSubmitElement.created() : super.created();
}