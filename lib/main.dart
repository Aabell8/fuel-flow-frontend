import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelflow/dashboard.dart';
import 'package:fuelflow/model/party.dart';
import 'package:fuelflow/service/requests.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fuel Flow',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        buttonColor: Colors.amber,
        accentColor: Colors.amber,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        primaryColorBrightness: Brightness.dark,
        secondaryHeaderColor: Colors.amber,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final inputController = TextEditingController();
  final nameController = TextEditingController();

  void _handleJoin(String party, String name) async {
    final response = await fetchParty(party.toUpperCase());
    if (response.statusCode == 200) {
      Party result = Party.fromJson(json.decode(response.body));
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new DashboardPage(
                    party: result,
                    name: name,
                  )));
    } else {
      showInSnackBar("Could not find party with that id");
    }
  }

  void _handleCreate(String name) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new DashboardPage(name: name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Fuel Flow"),
      ),
      body: new Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const SizedBox(height: 64.0),
              new TextField(
                keyboardType: TextInputType.text,
                controller: inputController,
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter party code:',
                  prefixText: '\# ',
                  prefixStyle: TextStyle(color: Colors.amber),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24.0),
              new TextField(
                keyboardType: TextInputType.text,
                controller: nameController,
                decoration: new InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter name:',
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24.0),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton.icon(
                        icon: const Icon(Icons.person_add, size: 18.0),
                        label: const Text('JOIN PARTY'),
                        onPressed: () {
                          if (nameController.text != "") {
                            _handleJoin(
                                inputController.text, nameController.text);
                          } else {
                            showInSnackBar("Please enter a name");
                          }
                        },
                        color: Colors.amber),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton.icon(
                      icon: const Icon(Icons.add, size: 18.0),
                      label: const Text('CREATE PARTY'),
                      onPressed: () {
                        if (nameController.text != "") {
                          _handleCreate(nameController.text);
                        } else {
                          showInSnackBar("Please enter a name");
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    inputController.dispose();
    super.dispose();
  }
}
