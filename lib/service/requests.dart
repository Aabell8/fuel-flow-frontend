import 'package:http/http.dart' as http;

String baseUrl = "http://ec2-18-224-171-112.us-east-2.compute.amazonaws.com";

Future<http.Response> fetchParty(String input) {
  return http.get('$baseUrl:5000/parties/$input');
}

Future<http.Response> postParty() {
  return http.post('$baseUrl:5000/parties/');
}

Future<http.Response> postPerson(String partyId, String person) {
  Map data = {
    "id": person,
    "name": person,
  };
  return http.put('$baseUrl:5000/parties/$partyId/people',
      body: data);
}

Future<http.Response> sendDrinkRequest(String partyId, String person) {
  return http.put('$baseUrl:5000/parties/$partyId/people/$person');
}
