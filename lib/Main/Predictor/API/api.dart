import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  _getApiData(String url, String accessTerm) async {
    List values = [];
    http.Response fetchUrl = await http.get('$url');

    if (fetchUrl.statusCode == 200) {
      String data = fetchUrl.body;
      var temp = jsonDecode(data);
      var res = temp['$accessTerm'] as Map;
      res.forEach((key, value) {
        values.add(value);
      });
    }
    return values;
  }

  _getImageData(String url) async {
    http.Response fetchUrl = await http.get(url);

    if (fetchUrl.statusCode == 200) {
      String data = fetchUrl.body;
      return data;
    }
  }

  Future getTruthDeathData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/truth_death',
        'totaldeceased');
  }

  Future getPredictedDeathData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/predict_death',
        'pred');
  }

  Future getTruthCasesData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/truth_cases',
        'totalconfirmed');
  }

  Future getPredictedCasesData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/predict_cases',
        'pred');
  }

  Future getTruthRecoveryData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/truth_recovery',
        'dailyrecovered');
  }

  Future getPredictedRecoveryData() async {
    return await _getApiData(
        'https://covpred-new.herokuapp.com/api/v1/resources/predict_recovery',
        'pred');
  }

  Future getDeathImage() async {
    return await _getImageData(
        'https://cov-pred-images.herokuapp.com/api/v1/resources/predict_death');
  }

  Future getCasesImage() async {
    return await _getImageData(
        'https://cov-pred-images.herokuapp.com/api/v1/resources/predict_cases');
  }

  Future getRecoveryImage() async {
    return await _getImageData(
        'https://cov-pred-images.herokuapp.com/api/v1/resources/predict_recovery');
  }
}
