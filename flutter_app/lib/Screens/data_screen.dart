import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_helth/Models/Student.dart';
import 'package:green_helth/Services/FaceRecognitionApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {

  var badgeFreq = [["Green", 167, Color.fromRGBO(11, 192, 127, 1)], ["Yellow", 46, Color.fromRGBO(245, 224, 34, 1)], ["Red", 11, Color.fromRGBO(242, 48, 118, 1)]];
  late TooltipBehavior _tooltipBehavior;
  late CrosshairBehavior _crosshairBehavior;

  @override
  void initState(){
    _tooltipBehavior = TooltipBehavior(enable: true, header: "");
    _crosshairBehavior = CrosshairBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Badge Counts",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline
              ),
            ),
            Text(
              "Last 30 days",
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontStyle: FontStyle.italic
              ),
            ),
            Container(
              width: 450,
              height: 450,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // crosshairBehavior: _crosshairBehavior,
                tooltipBehavior: _tooltipBehavior,
                series: [
                  ColumnSeries(
                      dataSource: badgeFreq,
                      xValueMapper: (List x, _) {
                        return x[0];
                      },
                      yValueMapper: (List y, _) {
                        return y[1];
                      },
                      pointColorMapper: (List z, _) {
                        return z[2];
                      },
                      dataLabelMapper: (List w, _) {
                        return w[0];
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
