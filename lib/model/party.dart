import 'package:fuelflow/model/person.dart';

class Party {
  final String id;
  final List<Person> people;

  Party({this.id, this.people});

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
        id: json['_id'],
        people:
            (json['people'] as List).map((i) => Person.fromJson(i)).toList());
  }
}
