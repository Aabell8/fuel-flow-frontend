class Person {
  String id;
  String name;
  bool isRequesting;
  int drinks;

  Person({this.id, this.name, this.isRequesting = false, this.drinks});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'] as String,
      name: json['name'] as String,
      isRequesting: json['isRequesting'] != null ? json['isRequesting'] : false,
      drinks: json['drinks'] as int,
    );
  }
}

var testPeople = <Person>[
  Person(id: '1', name: "Austin Abell", drinks: 0),
  Person(id: '2', name: "Austin Baggio", drinks: 0),
  Person(id: '3', name: "Calvin Zehr", drinks: 0),
];
