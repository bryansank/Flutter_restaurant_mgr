import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_mgr/services/Firebase_auth_utils.dart';

enum STATE {SIGNIN,SIGNUP,}

class SignInSignUpPage extends StatefulWidget {
  final AuthFunc auth;
  final VoidCallback onSignedIn;
  SignInSignUpPage({this.auth, this.onSignedIn});
  @override
  _SignInSignUpPage createState() => new _SignInSignUpPage();
}

class _SignInSignUpPage extends State<SignInSignUpPage> {

  final _formKey = new GlobalKey<FormState>();
  String _email, _password, _errorMessage;
  STATE _formState = STATE.SIGNIN;
  bool _isIos, _isLoading;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async{
    
    showCircularProgress();
  
    setState(() {
      _errorMessage = "";
      _isLoading = true;
      });

    if (_validateAndSave()){
      String userId = "";

      try {
        if (_formState == STATE.SIGNIN){

          userId = await widget.auth.signIn(_email, _password);

        }else{

          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();

        }
        
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _formState == STATE.SIGNIN) {
          widget.onSignedIn();
        }
        
      } catch (e) {
        print(e);

        setState(() {
            _isLoading = false;
            if (_isIos) {
              _errorMessage = e.details;
            } else {
              _errorMessage = e.message;
            }
          }
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }

//--> _changeFormToSignUp for ChangeForm at FormLogin FINAL CODE

  void _changeFormToSignIn() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formState = STATE.SIGNIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    
    return new Scaffold(
      backgroundColor: Colors.deepOrange,
      resizeToAvoidBottomPadding: true,
      
      body: Column(
        children: <Widget>[
          new Container(
            child: new Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: (Image.asset("assets/img/restapp.png")),
                        ),
                        new Text(
                          " Arturo´s",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Expanded(
            flex: 0,
            child: showBody(),
          ),
          new Expanded(
            flex: 0,
            child :Row(
              children: <Widget>[
                showCircularProgress(),
                new SizedBox(
                  height: 10.0,
                  width: 10.0,
                ),
                _showButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('gracias'),
            content: new Text('link en tu email'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  _changeFormToSignIn();
                  Navigator.of(context).pop();
                },
                child: new Text('ok'),
              ),
            ],
          );
        });
  }

  showBody() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: new Container(
        width: 380.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 15.0),
              blurRadius: 8.0
            ),
          ],
        ),
        child: new Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Form(
                key: _formKey,
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _showText(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    //_showButton(),
                    //_showAskQuestion(),
                    _showErrorMessage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showText() {
  return new Hero(
    tag: 'Texto Hero',
    child: new Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
      child: _formState == STATE.SIGNIN
          ? new Center(
              child: Text(
                'Credenciales',
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          : new Center(
              //Register Page abajo...
              child: Text(
                'Registrate.',
                style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
    ),
  );
  }

  showCircularProgress() {
    
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

//-->  _showAskQuestion for Create Account in FirebaseAuth  FINAL CODE
  Widget _showEmailInput() {
    
    return new Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Correo',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'ESTA VACIO' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );

  }

  Widget _showPasswordInput() {
    return new Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 20.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Contraseña',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'ESTA VACIO' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showButton() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 0.0, left: 95.0, right: 0.0, top: 0.0),
      child: new InkWell(
        child: new Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 15.0),
              blurRadius: 8.0
            ),
          ],
        ),
          height: 40.0,
          width: 200.0,
          child: new Material(
            color: Colors.transparent,
            child: new InkWell(
              onTap: _validateAndSubmit,
              child: Center(
                child: _formState == STATE.SIGNIN
                ? new Text(
                    'Entrar',
                    style:new TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  )
                : new Text(
                    'volver',
                    style:new TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: new Center(
          child: new Text(
            _errorMessage,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
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

// TRASH CODE

//_showAskQuestion---->

/*Widget _showAskQuestion() {
    return new FlatButton(
      child: _formState == STATE.SIGNIN
          ? new Text(
              'crear cuenta',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            )
          : new Text(
              'list?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            ),
      onPressed: _formState == STATE.SIGNIN
          ? _changeFormToSignUp
          : _changeFormToSignIn,
    );
  }*/

//---> _changeFormToSignUp

/*void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formState = STATE.SIGNUP;
    });
  }*/
