import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

Future<String> getimage(String city, String place) async {
  try {
    var res = await http.get(
      Uri.parse(
        "https://api.unsplash.com/search/photos?query=${city}'s ${place}&client_id=1Xqr_Y89E8vmYwGUoyEXBz1tPtUVMNYJR0o6uh9mtKM",
      ),
    );
    var data = jsonDecode(res.body);
    return data['results'][0]['urls']['small'];
  } catch (e) {
    log(e.toString());
  }
  return '';
}
