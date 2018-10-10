import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuelflow/components/TaskListItem.dart';
import 'package:fuelflow/model/party.dart';
import 'package:fuelflow/model/person.dart';

import 'package:http/http.dart' as http;
import 'dart:async';

class DashboardPage extends StatefulWidget {
  const DashboardPage({this.party});

  final Party party;

  @override
  DashboardPageState createState() => new DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  Party party;

  @override
  initState() {
    super.initState();
    if (widget.party != null) {
      party = widget.party;
    } else {
      postParty().then((result) {
        if (result.statusCode == 200) {
          setState(() {
            party = Party.fromJson(json.decode(result.body));
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
    return TaskListItem(item);
  }
}

Future<http.Response> postParty() {
  return http.post('http://localhost:5000/parties/');
}
