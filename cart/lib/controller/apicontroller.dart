import 'dart:convert';

import 'package:http/http.dart' as http;


class API{

  // static Future<dynamic> callAPIjwt(String method, String url, Map data) async{
  //   try{
  //     print(url);
  //     // SECERT_JWT = '1234567890';
  //     // R_USER = '11223344';
  //     var headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     var body = json.encode(data);
  //     ///'https://agilesoftgroup.com'
  //     var request = http.Request(method, Uri.parse(url));
  //     request.body = json.encode(body);
  //     ///encrypbody require genTokenEncryp()
  //     request.headers.addAll(headers);
  //     http.StreamedResponse response = await request.send();
  //     var dataRaw = await response.stream.bytesToString();
  //     var responseData = json.decode(dataRaw);
  //     return responseData;
  //   }catch(e){
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return false;
  //   }
  // }
  static Future<dynamic> wranglerGet(String url) async{
    print("wranglerGet");
    var headers = {
      'Content-Type': 'application/json'
    };

    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var dataRaw = await response.stream.bytesToString();

    var responseData = json.decode(dataRaw);

    return responseData;
  }

  static Future<dynamic> wranglerPost(String url, Map data) async{
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(url));
    request.body = json.encode(data);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    var dataRaw = await response.stream.bytesToString();

    var responseData = json.decode(dataRaw);

    return responseData;
  }

  Future<void> fetchGetApiData(url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Successful response, you can parse the JSON data
      final jsonData = json.decode(response.body);
      // Do something with jsonData
      return jsonData;
    } else {
      // Handle error cases
      print('Request failed with status: ${response.statusCode}');
    }
  }

}