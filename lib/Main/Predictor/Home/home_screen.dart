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
  Image deathImage, casesImage, recoveryImage;

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
              _api.getPredictedRecoveryData(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Icon(Icons.error, color: Colors.black));
              }
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff520935))));
              if (snapshot.hasData) {
                for (var snap in snapshot.data[0])
                  truthDeath.add(snap.toDouble());

                for (var snap in snapshot.data[1])
                  predictedDeaths.add(snap.toDouble());

                for (var snap in snapshot.data[2])
                  truthCases.add(snap.toDouble());

                for (var snap in snapshot.data[3])
                  predictedCases.add(snap.toDouble());

                for (var snap in snapshot.data[4])
                  truthRecovery.add(snap.toDouble());

                for (var snap in snapshot.data[5])
                  predictedRecovery.add(snap.toDouble());

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
                      child: Index().chartItem("Deaths So Far", true,
                          _api.getDeathImage(), truthDeath, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem("Predicted Deaths", false,
                          _api.getDeathImage(), predictedDeaths, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem("Cases So Far", true,
                          _api.getCasesImage(), truthCases, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem("Predicted Cases", false,
                          _api.getCasesImage(), predictedCases, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem("Patients Recovered", true,
                          _api.getRecoveryImage(), truthRecovery, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Index().chartItem("Predicted Recoveries", false,
                          _api.getRecoveryImage(), predictedRecovery, context),
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
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
