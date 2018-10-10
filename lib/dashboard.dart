import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuelflow/components/TaskListItem.dart';
import 'package:fuelflow/model/party.dart';
import 'package:fuelflow/model/person.dart';

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
        appBar: AppBar(
          title: Text("Party #${party.id}"),
        ),
        body: new Scrollbar(
          child: new ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: party.people.toList().map(buildListTile).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {
            sendDrinkRequest(party.id, name).then((response) {
              if (response.statusCode == 200) {
                setState(() {
                  party = Party.fromJson(json.decode(response.body));
                });
              } else {
                print("Invalid request");
              }
            });
          },
        ),
      );
    } else {
      return new Scaffold(
        appBar: AppBar(
          title: Text("Loading.."),
        ),
      );
    }
  }

  Widget buildListTile(Person item) {
    return TaskListItem(item, () => verifyDrink(item));
  }

  void verifyDrink(Person person) {
    http
        .put(
            'http://192.168.1.83:5000/parties/${party.id}/people/${person.id}/verify')
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
}

Future<http.Response> postParty() {
  return http.post('http://192.168.1.83:5000/parties/');
}

Future<http.Response> postPerson(String partyId, String person) {
  Map data = {
    "id": person,
    "name": person,
  };
  return http.put('http://192.168.1.83:5000/parties/$partyId/people',
      body: data);
}

Future<http.Response> sendDrinkRequest(String partyId, String person) {
  return http.put('http://192.168.1.83:5000/parties/$partyId/people/$person');
}
