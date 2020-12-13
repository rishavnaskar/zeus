import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:zeus/Main/Predictor/API/api.dart';
import 'Components/index.dart';

class PredictorHomeScreen extends StatefulWidget {
  @override
  _PredictorHomeScreenState createState() => _PredictorHomeScreenState();
}

class _PredictorHomeScreenState extends State<PredictorHomeScreen> {
  Api _api = Api();
  List<double> truthDeath = [];
  List<double> predictedDeaths = [];
  List<double> truthCases = [];
  List<double> predictedCases = [];
  List<double> truthRecovery = [];
  List<double> predictedRecovery = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder(
              future: Future.wait([
                _api.getTruthDeathData(),
                _api.getPredictedDeathData(),
                _api.getTruthCasesData(),
                _api.getPredictedCasesData(),
                _api.getTruthRecoveryData(),
                _api.getPredictedRecoveryData()
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData || snapshot.hasError)
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff520935))));
                for (var snap in snapshot.data[0]) {
                  truthDeath.add(snap.toDouble());
                }
                for (var snap in snapshot.data[1]) {
                  predictedDeaths.add(snap.toDouble());
                }
                for (var snap in snapshot.data[2]) {
                  truthCases.add(snap.toDouble());
                }
                for (var snap in snapshot.data[3]) {
                  predictedCases.add(snap.toDouble());
                }
                for (var snap in snapshot.data[4]) {
                  truthRecovery.add(snap.toDouble());
                }
                for (var snap in snapshot.data[5]) {
                  predictedRecovery.add(snap.toDouble());
                }
                return StaggeredGridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text('The predictions are based on the data available',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 17)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index()
                          .chartItem("Deaths So Far", truthDeath, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem(
                          "Predicted Deaths", predictedDeaths, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index()
                          .chartItem("Cases So Far", truthCases, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem(
                          "Predicted Cases", predictedCases, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem(
                          "Patients Recovered", truthRecovery, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem(
                          "Predicted Recoveries", predictedRecovery, context),
                    ),
                  ],
                  staggeredTiles: [
                    StaggeredTile.count(4, 0.3),
                    StaggeredTile.count(4, 0.7),
                    StaggeredTile.extent(4, 200),
                    StaggeredTile.extent(4, 200),
                    StaggeredTile.extent(4, 200),
                    StaggeredTile.extent(4, 200),
                    StaggeredTile.extent(4, 200),
                    StaggeredTile.extent(4, 200),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
