import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  _getApiData(String url, String accessTerm) async {
    List list = [];
    http.Response fetchUrl = await http
        .get('$url');

    if (fetchUrl.statusCode == 200) {
      String data = fetchUrl.body;
      var temp = jsonDecode(data);
      var res = temp['$accessTerm'] as Map;
      res.forEach((key, value) => list.add(value));
    }
    return list;
  }

  Future getTruthDeathData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/truth_death', 'totaldeceased');
  }
  
  Future getPredictedDeathData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/predict_death', 'totaldeceased');
  }
  
  Future getTruthCasesData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/truth_cases', 'totalconfirmed');
  }
  Future getPredictedCasesData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/predict_cases', '0');
  }
  Future getTruthRecoveryData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/truth_recovery', 'dailyrecovered');
  }
  Future getPredictedRecoveryData() async {
    return await _getApiData('https://scam-2020.herokuapp.com/api/v1/resources/predict_recovery', '0');
  }
}
