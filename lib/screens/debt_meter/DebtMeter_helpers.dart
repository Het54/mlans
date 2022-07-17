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
              hintText: "Enter your monthly income...",
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
              hintText: "Enter your monthly payments...",
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
              double val = ( double.parse(debtsController.text) / double.parse(earningsController.text) * 100 );
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return debtMeterCheck(
                        context,
                        val
                    );
                  });
              debtsController.clear();
              earningsController.clear();
              notifyListeners();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
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
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green.shade200,
            borderRadius: BorderRadius.circular(15)),
        height: MediaQuery.of(context).size.height * 0.65,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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

              SizedBox(
                height: 15,
              ),

              if (debtScore < 35)
                Text(
                  "Healthy",
                  style: TextStyle(
                      color: Colors.green[500],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              else if (debtScore > 35 && debtScore < 50)
                Text(
                  "Moderate",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 123, 7),
                    fontSize: 20,
                  ),
                )
              else
                Text(
                  "Unhealthy",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 0, 0),
                    fontSize: 20,
                  ),
                ),

              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: KdGaugeView(
                    minSpeed: 0,
                    maxSpeed: 100,
                    speed: debtScore,
                    animate: true,
                    duration: Duration(seconds: 5),
                    alertSpeedArray: [35, 50],
                    alertColorArray: [Colors.orange, Colors.red],
                    unitOfMeasurement: " \n \n \n Debt-O-Score  ",
                    unitOfMeasurementTextStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    gaugeWidth: 15,
                    fractionDigits: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  debtScoreFunc(TextEditingController incomeController,
      TextEditingController debtController) {
    var income = double.parse(incomeController.text);
    var debt = double.parse(debtController.text);

    var debtScoreValue = (debt / income) * 10;
    return debtScoreValue;
  }
}
