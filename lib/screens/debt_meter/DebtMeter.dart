import 'package:Moneylans/screens/debt_meter/DebtMeter_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtMeter extends StatefulWidget {
  const DebtMeter({Key? key}) : super(key: key);

  @override
  State<DebtMeter> createState() => _DebtMeterState();
}

class _DebtMeterState extends State<DebtMeter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        /*leading: GestureDetector(
            onTap: ()=> Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 16)),*/
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        title: const Text(
          "Moneylans",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Provider.of<DebtMeterHelpers>(context, listen: false)
                    .debtMeterValue(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
