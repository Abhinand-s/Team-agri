import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For charting the growth analysis
import 'package:google_fonts/google_fonts.dart'; // For better font styles

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random _random = Random();

  // Dummy data for plant growth that changes every time
  List<Data> getData() {
    return List.generate(4, (index) {
      return Data('Stage ${index + 1}', _random.nextDouble() * 5);
    });
  }

  // Dummy data for real-time system overview
  String getRandomValue(String unit) {
    double value = _random.nextDouble() * 100;
    return value.toStringAsFixed(1) + unit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agri Dashboard',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Real-time data display
              Text(
                'System Overview',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 10),

              // Row 1: Two data cards
              Row(
                children: [
                  Expanded(
                    child: DataCard(
                      icon: Icons.opacity,
                      title: 'pH Value',
                      value: getRandomValue(''),
                      unit: '',
                      color: Colors.teal[100]!,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DataCard(
                      icon: Icons.science,
                      title: 'TDS Rate',
                      value: getRandomValue(' ppm'),
                      unit: 'ppm',
                      color: Colors.teal[200]!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Row 2: Two data cards
              Row(
                children: [
                  Expanded(
                    child: DataCard(
                      icon: Icons.health_and_safety,
                      title: 'Plant Health',
                      value: 'Healthy',
                      unit: '',
                      color: Colors.teal[300]!,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DataCard(
                      icon: Icons.thermostat,
                      title: 'Temperature',
                      value: getRandomValue('°C'),
                      unit: '°C',
                      color: Colors.teal[100]!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Row 3: Two data cards
              Row(
                children: [
                  Expanded(
                    child: DataCard(
                      icon: Icons.water_damage,
                      title: 'Humidity',
                      value: getRandomValue('%'),
                      unit: '%',
                      color: Colors.teal[200]!,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DataCard(
                      icon: Icons.check_circle,
                      title: 'System Status',
                      value: 'Optimal',
                      unit: '',
                      color: Colors.teal[300]!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Section 2: Plant Growth Analysis
              Text(
                'Plant Growth Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                    text: 'Plant Growth Over Time',
                    textStyle: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  legend: Legend(isVisible: true, textStyle: TextStyle(color: Colors.green[800])),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <LineSeries<Data, String>>[
                    LineSeries<Data, String>(
                      dataSource: getData(),
                      xValueMapper: (Data data, _) => data.stage,
                      yValueMapper: (Data data, _) => data.growth,
                      name: 'Growth Rate',
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(color: Colors.green[900]),
                      ),
                      color: Colors.green[700],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Section 3: Nutrient Recommendations
              Text(
                'Nutrient Recommendations',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Based on the current and previous growth stages, we recommend the following nutrients:',
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
              ),
              SizedBox(height: 10),
              NutrientCard(nutrient: 'Nitrogen', amount: 'Medium'),
              NutrientCard(nutrient: 'Phosphorus', amount: 'Low'),
              NutrientCard(nutrient: 'Potassium', amount: 'High'),
            ],
          ),
        ),
      ),
    );
  }
}

class Data {
  final String stage;
  final double growth;

  Data(this.stage, this.growth);
}

// Card to display real-time data
class DataCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  DataCard({required this.title, required this.value, required this.unit, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green[800]),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green[900]),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          if (unit.isNotEmpty) Text(unit, style: TextStyle(color: Colors.green[900])),
        ],
      ),
    );
  }
}

// Card for nutrient recommendation
class NutrientCard extends StatelessWidget {
  final String nutrient;
  final String amount;

  NutrientCard({required this.nutrient, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nutrient,
            style: TextStyle(fontSize: 18, color: Colors.green[900]),
          ),
          Text(
            amount,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
        ],
      ),
    );
  }
}
