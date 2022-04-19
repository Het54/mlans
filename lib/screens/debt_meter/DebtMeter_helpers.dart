import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

class DebtMeterHelpers with ChangeNotifier {
  TextEditingController earningsController = TextEditingController();
  TextEditingController debtsController = TextEditingController();
  double debtScore = 0.0;

  debtMeterValue(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 15),
          TextField(
            controller: earningsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter your monthly earnings...",
              prefix: Text(
                "₹",
                style: TextStyle(color: Colors.black),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: debtsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter your monthly debts...",
              prefix: Text(
                "₹",
                style: TextStyle(color: Colors.black),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              debtScore = debtScoreFunc(earningsController, debtsController);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return debtMeterCheck(context, debtScore);
                  });
              debtsController.clear();
              earningsController.clear();
              notifyListeners();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text("Check now!"),
              ),
            ),
          ),
          SizedBox(height: 40),
          Image.asset(
            "assets/gifs/money.gif",
            height: 350.0,
            width: 350.0,
          ),
        ],
      ),
    );
  }

  debtMeterCheck(BuildContext context, double debtScore) {
    return Dialog(
      child: Container(
        color: Colors.green.shade200,
        height: MediaQuery.of(context).size.height * 0.61,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Moneylans",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                          fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  height: 400,
                  padding: EdgeInsets.all(10),
                  child: KdGaugeView(
                    minSpeed: 0,
                    maxSpeed: 100,
                    speed: debtScore,
                    animate: true,
                    duration: Duration(seconds: 5),
                    alertSpeedArray: [40, 80, 90],
                    alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                    unitOfMeasurement: " \n \n \n Debt-O-Score  ",
                    unitOfMeasurementTextStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    gaugeWidth: 15,
                    fractionDigits: 1,
                  ),
                ),
                Text(
                  "Lower the debt-o-score, better it is!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 102, 150, 106),
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double debtScoreFunc(TextEditingController incomeController,
      TextEditingController debtController) {
    int income = int.parse(incomeController.text);
    int debt = int.parse(debtController.text);

    double debtScoreValue = debt / income;
    return debtScoreValue;
  }
}
