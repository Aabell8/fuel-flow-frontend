import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelflow/components/TaskListItem.dart';
import 'package:fuelflow/model/party.dart';
import 'package:fuelflow/model/person.dart';
import 'package:fuelflow/service/requests.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.party, this.name});

  final Party party;
  final String name;

  @override
  DashboardPageState createState() => new DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  Party party;
  String name;
  bool isRequesting = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    if (widget.party != null) {
      // party = widget.party;
      List<Person> people = widget.party.people;
      String pName = widget.name;
      bool found = false;
      for (var i = 0; i < people.length; i++) {
        if (people[i].name.toLowerCase() == pName.toLowerCase()) {
          setState(() {
            party = widget.party;
            name = pName;
          });
          found = true;
          isRequesting = people[i].isRequesting || false;
        }
      }
      if (!found) {
        postPerson(widget.party.id, pName).then((response) {
          if (response.statusCode == 200) {
            setState(() {
              party = Party.fromJson(json.decode(response.body));
              name = pName;
            });
          } else {
            print("Invalid post to party");
          }
        });
      }
    } else {
      postParty().then((result) {
        if (result.statusCode == 200) {
          Party created = Party.fromJson(json.decode(result.body));
          postPerson(created.id, widget.name).then((response) {
            if (response.statusCode == 200) {
              setState(() {
                party = Party.fromJson(json.decode(response.body));
                name = widget.name;
              });
            } else {
              print("Invalid post to party");
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (party != null) {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Party #${party.id}"),
        ),
        body: RefreshIndicator(
          child: new Scrollbar(
            child: new ListView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: party.people.toList().map(buildListTile).toList(),
            ),
          ),
          onRefresh: _handleRefresh,
        ),
        floatingActionButton: !isRequesting
            ? FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.amber,
                onPressed: () {
                  sendDrinkRequest(party.id, name).then((response) {
                    if (response.statusCode == 200) {
                      setState(() {
                        party = Party.fromJson(json.decode(response.body));
                        isRequesting = true;
                      });
                    } else {
                      print("Invalid request");
                    }
                  });
                },
              )
            : null,
      );
    } else {
      return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Loading.."),
        ),
      );
    }
  }

  Widget buildListTile(Person item) {
    return TaskListItem(item, () => verifyDrink(item, name), name);
  }

  void verifyDrink(Person person, String verifier) {
    http
        .put(
            'http://192.168.1.83:5000/parties/${party.id}/people/${person.id}/verify/$verifier')
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          party = Party.fromJson(json.decode(response.body));
        });
      } else {
        print("Invalid request");
      }
    });
  }

  Future<Null> _handleRefresh() {
    return fetchParty(party.id).then((response) {
      response.statusCode == 200
          ? setState(() {
              party = Party.fromJson(json.decode(response.body));
            })
          : showInSnackBar("refresh failed");
    });
  }

  void showInSnackBar(String value) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
    }
  }
}
