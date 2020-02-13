import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:restaurant_mgr/views/MyDataRest.dart';

class ShowDataRestPage extends StatefulWidget {
  @override
  _ShowDataRestPageState createState() => _ShowDataRestPageState();
}

class _ShowDataRestPageState extends State<ShowDataRestPage> {
  List<MyDataRest> allData = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('warehouses').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();

      for (var keyRest in keys) {
        MyDataRest d = new MyDataRest(
          keyRest,
          data[keyRest]['date'],
          data[keyRest]['modified'],
          data[keyRest]['status'],
          data[keyRest]['updated'],
        );
        //print(data);//print('$bryanvar');//print('${allData[0].toString()}');
        allData.add(d);
      }
      setState(() {/*print('Length : ${allData.length}');*/});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: new Container(
          child: allData.length == 0
              ? new Center(
                  child: new Text(
                    'Cargando...',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                )
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (_, index) {
                    return viewUI(
                      allData[index].codeRest,
                      allData[index].date,
                      allData[index].modified,
                      //allData[index].movil,
                      allData[index].status,
                      allData[index].updated,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget viewUI(String codeRest, String date, String modified, String status, String updated){    
    return new Card(
      elevation: 20.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              '$codeRest',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              'Date : $date',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            new Text(
              'Modified : $modified',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            new Text(
              'Status : $status',
              style: status == 'success' ? TextStyle(
                fontSize: 23.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ) : TextStyle(
                fontSize: 23.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              'Updated : $updated',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//--> Custom Rest

class ShowDataRestPageFilter extends StatefulWidget {
  @override
  _ShowDataRestPageFilterState createState() => _ShowDataRestPageFilterState();
}

class _ShowDataRestPageFilterState extends State<ShowDataRestPageFilter> {
  List<MyDataRest> allData = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('warehouses').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var bryanvar in keys) {
        MyDataRest d = new MyDataRest(
          bryanvar,
          data[bryanvar]['date'],
          data[bryanvar]['modified'],
          //data[key]['movil'],
          data[bryanvar]['status'],
          data[bryanvar]['updated'],
        );
        //print(data);//print('$bryanvar');//print('${allData[0].toString()}');
        allData.add(d);
      }
      setState(() {/*print('Length : ${allData.length}');*/});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Filtrado de Restaurantes',
            style: TextStyle(
              fontSize: 25, 
              fontWeight: FontWeight.w500, 
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        body: new Container(
          child: allData.length == 0
              ? new Center(
                  child: new Text(
                    'Cargando...',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                )
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (_, index) {
                    return viewUI(
                      allData[index].codeRest,
                      allData[index].date,
                      allData[index].modified,
                      allData[index].status,
                      allData[index].updated,
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget viewUI(String codeRest, String date, String modified, String status,String updated){    
    return new Card(
      elevation: 20.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              '$codeRest',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              'Date : $date',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            new Text(
              'Modified : $modified',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            new Text(
              'Status : $status',
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              'Updated : $updated',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
