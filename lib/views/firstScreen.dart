import 'package:flutter/material.dart';
import 'package:restaurant_mgr/views/ShowDataRestPage.dart';

class FirstScreenState extends StatefulWidget {
  @override
  ScreenRestList createState() => ScreenRestList();
}

class ScreenRestList extends State<FirstScreenState> {
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
          title: Text(
            'Restaurantes',
            style: TextStyle(
              fontSize: 35, 
              fontWeight: FontWeight.w500, 
              color: Colors.white,
            ),
          ),
          bottom: PreferredSize(
            child: Text(''),
            preferredSize: Size.fromHeight(10.0),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15.0,
            child: Image.asset(
            "assets/img/restapp.png",
            ),
          ),/*IconButton(
            padding: EdgeInsets.only(right: 5.0),
            iconSize: 20.0,
            /*
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20.0,
              child: Image.asset(
              "assets/img/restapp.png",
              ),
            ),
            */
            //onPressed: () => {Navigator.pushNamed(context, "/FirstScreen")},
          ),*/
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 5.0),
              iconSize: 25.0,
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25.0,
                child: Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                  size: 40.0,
                ),
              ),
              onPressed: () {Navigator.pushNamed(context, "/authservice");},
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
              child: new ShowDataRestPage(),
            ),
          ],
        ),
      ),
    );
  }
}