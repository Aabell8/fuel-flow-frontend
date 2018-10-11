import 'package:http/http.dart' as http;

Future<http.Response> fetchParty(String input) {
  return http.get('http://192.168.1.83:5000/parties/$input');
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