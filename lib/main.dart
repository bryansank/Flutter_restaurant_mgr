import 'package:flutter/material.dart';
import 'package:restaurant_mgr/services/AuthenticateService.dart';
import 'package:restaurant_mgr/views/ShowDataRestPage.dart';
import 'package:restaurant_mgr/views/firstScreen.dart';
import 'package:restaurant_mgr/Widgets/splashscreenCode.dart';

void main() => runApp(RestaurantManager());

class RestaurantManager extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      initialRoute: '/',
      routes: {
        '/' : (context) => InitialPage(),
        '/FirstScreen' : (context) => FirstScreenState(),
        '/authservice': (context) => AuthenticateService(),
        '/ShowRest' : (context) => ShowDataRestPageFilter(),
      },
    );
  }
}

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => new _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: '/FirstScreen',
        title: Text(
          "Arturo´s",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        image: Image.asset("assets/img/restapp.png"),
        backgroundColor: Colors.deepOrange,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 60.0,
        loaderColor: Colors.black,
        loadingText: Text(
          "Cargando Datos... \nPor favor espere.",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
    );
  }
}
