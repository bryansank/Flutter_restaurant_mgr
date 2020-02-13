import 'package:firebase_database/firebase_database.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_mgr/services/Firebase_auth_utils.dart';

class UpdateRatess extends StatefulWidget {

  final AuthFunc auth;
  final VoidCallback onSignOut;
  final String userId, userEmail;

  UpdateRatess({Key key, this.auth, this.onSignOut, this.userId, this.userEmail}): super(key: key);

  @override
  _UpdateRatesState createState() => _UpdateRatesState();
}

class _UpdateRatesState extends State<UpdateRatess> {

  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  String _time;
  String _rate;
  int _rateNum;
  DateTime _date = DateTime.now();

  Future<Null> selectDate(BuildContext context) async{ 
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );
    
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        _time = _date.toString();
        print('Fecha seleccionada ---> $_time');
      });
    }
  }

  @override
  Widget build(BuildContext buildContext){
    return new SafeArea(
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(right: 5.0),
              iconSize: 30.0,
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  Icons.add_to_home_screen,
                  color: Colors.deepOrange,
                  size: 35.0,
                ),
              ),
              onPressed: () => _signOut(),
            ),
          ],
        ),
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(decoration: BoxDecoration(color: Colors.deepOrange),),
            new Container(
              padding: const EdgeInsets.all(0.0),
              child: new Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: formUIWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formUIWidget(){
    return new Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 5.0),
      child: formContentWidget(),
    );
  }

  Widget formContentWidget(){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // HEAD 
        logoHead(),
        new SizedBox(height: 18.0,),
        //
        contentForm(),
        //
        buttonForm(),
      ],
    );
  }

  Widget logoHead(){
    return new Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40.0,
          child: (Image.asset("assets/img/restapp.png")),
        ),
        Text(
          " Arturo´s",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget contentForm(){
    return new Container(
      width: double.infinity,
      height: 240.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            offset: Offset(5.0, 15.0),
            blurRadius: 5.0,
          ),
          new BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -10.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: new Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            titleForm(),
            Text(
              "Ingrese Tasa del dolar",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Introduzca la tasa actual",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.5),
                errorStyle: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
              ],
              maxLength: 7,
              validator: (val) => val.isEmpty ? 'Introduzca una tasa valida' : null,
              onSaved: (val) => _rate = val,
            ),
            timeIconForm(),
            
          ],
        ),
      ),
      );
  }

  Widget titleForm(){
    return Column(
      children: <Widget>[
        Text(
        "Actualizar Tasa de Cambio",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 26.2,
          letterSpacing: .3,
        ),
      ),
//-->
        SizedBox(height: 25.0,),
      ],
    );
  }

  Widget buttonForm(){
    return new Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: new InkWell(
        child: new Container(
          width: 100,
          height: 40,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){_sendToFirebase();},
              child: new Center(
                child: new Text(
                  "Guardar",
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            gradient: LinearGradient(
              colors: [
                Color(0xFFffffff),
                Color(0xFFffffff),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6078ea).withOpacity(.3),
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0,
              ),
            ],
          ),
        ),
      ),
    );  
  }

  Widget timeIconForm(){
    return new Row(
      children: <Widget>[
        new IconButton(
          color: Colors.black,
          iconSize: 40.0,
          icon: Icon(Icons.alarm),
          onPressed: () {
            selectDate(context);
          },
        ),
        new Text(
          '${_time == null? _time = 'Introduzca fecha correspondiente' : _time.replaceAll('00:00:00.000', '')}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.black,
            fontWeight: FontWeight.bold,
            wordSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  void _sendToFirebase(){
    if (_formKey.currentState.validate()) {
      String timeFinal = _time.replaceAll('-','').replaceAll('00:00:00.000','');
      
      if(timeFinal == "Introduzca fecha correspondiente"){
        showSimpleFlushbarError(context);
        setState(() {
          _autovalidate = true;
        });
      }else{
         _formKey.currentState.save();
        showSimpleFlushbar(context);
        
        if(_rate == null){ _rate = 'Hubo un problema'; }else{ _rateNum = int.parse(_rate);}
        
        var data = {
          'movil':'true',
          'rate': _rate == 'Hubo un problema'? _rate : _rateNum,
          'time': _time,
        };

        databaseReference.child('devcurrentrates').child(timeFinal.trim()).set(data).then((v){
            _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  void showSimpleFlushbar(BuildContext context) {
    Flushbar(
      message: 'Tasa actualizada',
      mainButton: FlatButton(
        child: Text(
          'EXITO',
          style: TextStyle(color: Colors.green,fontSize: 20.0),
        ),
        onPressed: () {},
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showSimpleFlushbarError(BuildContext context) {
    Flushbar(
      message: 'Introduzca la tasa por favor.',
      mainButton: FlatButton(
        child: Text(
          'ERROR',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {},
      ),
      duration: Duration(seconds: 5),
    )..show(context);
  }

  void _signOut() async{ try{await widget.auth.signOut(); widget.onSignOut();} catch(e){ print(e);}}
}