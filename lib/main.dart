import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelflow/dashboard.dart';
import 'package:fuelflow/model/party.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

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
      home: Scaffold(
        body: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fuel Flow"),
      ),
      body: new Center(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: new TextField(
            keyboardType: TextInputType.text,
            controller: inputController,
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter party code:',
              prefixText: '\# ',
              prefixStyle: TextStyle(color: Colors.amber),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  final response =
                      await fetchParty(inputController.text.toUpperCase());
                  if (response.statusCode == 200) {
                    Party result = Party.fromJson(json.decode(response.body));
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new DashboardPage(party: result)));
                  } else {
                    showInSnackBar("Could not find party with that id");
                  }
                },
              ),
            ),
            maxLines: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => new DashboardPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    inputController.dispose();
    super.dispose();
  }
}

Future<http.Response> fetchParty(String input) {
  return http.get('http://localhost:5000/parties/$input');
}
