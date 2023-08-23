
import 'package:flutter/material.dart';
import 'package:untitled4logintuyotrial/resources/auth_methods.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    
    print('111111111111111111111111111111111111111111111');
    print(user.username);
    print(user.email);
     print(user.username);
     print('111111111111111111111111111111111111111111111');
   
    
    notifyListeners();
  }
}