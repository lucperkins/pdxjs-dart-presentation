import 'package:polymer/polymer.dart';

@CustomTag('x-auth-submit')
class AuthSubmitElement extends PolymerElement {
  @observable String username = 'username';
  @observable String password = 'password';
  
  AuthSubmitElement.created() : super.created();
}