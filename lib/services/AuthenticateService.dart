import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_mgr/services/Firebase_auth_utils.dart';
import 'package:restaurant_mgr/views/AuthenticationView.dart';
import 'package:restaurant_mgr/views/UpdateRates.dart';

//main
class AuthenticateService extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      home: new AuthenticationFul(
        auth: new FirebaseAuthClass()
      ),
    );
  }
  
}

class AuthenticationFul extends StatefulWidget {
  
  final AuthFunc auth;
  AuthenticationFul({this.auth});

  @override
  _AuthenticationFulState createState() => new _AuthenticationFulState();

}

enum AuthStatus{NOT_LOGIN, NOT_DETERMINED, LOGIN}

class _AuthenticationFulState extends State<AuthenticationFul> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId= "", _userEmail="";

  bool _isLoading;

  @override
  void initState(){
    super.initState();
    widget.auth.getCurrentUser().then((user){
      setState(() {
        if(user != null){
          _userId = user?.uid;
          _userEmail = user?.email;
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGIN : AuthStatus.LOGIN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    switch(authStatus)
    {
     case AuthStatus.NOT_DETERMINED:
        return _showLoading();
        break;
      case AuthStatus.NOT_LOGIN:
        return new SignInSignUpPage(
          auth:widget.auth, 
          onSignedIn: _onSignedIn
        );
        break;
      case AuthStatus.LOGIN:
        if(_userId.length > 0 && _userId != null){
        return new UpdateRatess(
          userId: _userId,
          userEmail: _userEmail,
          auth:widget.auth, 
          onSignOut: _onSignOut,
          );
        }else{
          return _showLoading();
        }
      break;
      default:
        return _showLoading();
      break;           
    }
  }

  void _onSignOut(){
    widget.auth.getCurrentUser().then((user){
      setState(() {
        authStatus = AuthStatus.NOT_LOGIN;
        _userId = _userEmail = "";
      });
    });
  }

  void _onSignedIn(){
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email.toString();
      });
      setState(() {
        authStatus = AuthStatus.LOGIN;
      });
    });
  }

  _showLoading() {

    new Timer(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });

    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 0.0,left: 20.0,right: 0.0,top: 1.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
        width: 0.0,
      );
    }

  }
}




