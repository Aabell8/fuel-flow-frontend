import 'package:http/http.dart' as http;

String baseUrl = "https://fuel-flow.herokuapp.com";

Future<http.Response> fetchParty(String input) {
  return http.get('$baseUrl/parties/$input');
}

Future<http.Response> postParty() {
  return http.post('$baseUrl/parties/');
}

Future<http.Response> postPerson(String partyId, String person) {
  Map data = {
    "id": person,
    "name": person,
  };
  return http.put('$baseUrl/parties/$partyId/people',
      body: data);
}

Future<http.Response> sendDrinkRequest(String partyId, String person) {
  return http.put('$baseUrl/parties/$partyId/people/$person');
}
