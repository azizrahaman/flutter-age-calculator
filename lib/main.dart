import 'package:flutter/material.dart';
import 'age.dart';

void main() {
  runApp(const MaterialApp(
    home: AgeCalc(),
  ));
}

class AgeCalc extends StatefulWidget {
  const AgeCalc({super.key});

  @override
  State<AgeCalc> createState() => _AgeCalcState();
}

class _AgeCalcState extends State<AgeCalc> {
  String selectedDate = "Pick Date";
  String calculatedDate = "0Y 0M 0D";
  DateTime? pickedDate = DateTime.now();
  var dob = TextEditingController();

  @override
  void initState() {
    super.initState();
    dob.text = pickedDate.toString();
  }

  dateCheck(str) {
    if (selectedDate.isEmpty || selectedDate == "null") {
      selectedDate = "Please pick a date!";
    }
  }

  Age calculateAge(DateTime birthdate) {
    final now = DateTime.now();
    int years = now.year - birthdate.year;
    int months = now.month - birthdate.month;
    int days = now.day - birthdate.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
      months += (months < 0) ? 12 : 0;
      days += (days < 0) ? 31 : 0;
    } else if (months > 0 && days < 0) {
      months--;
      days += 31;
    }

    return Age(year: years, month: months, days: days);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Age Calculator"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  controller: dob,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2099),
                    );
                    setState(() {
                      pickedDate = date;
                      dateCheck(selectedDate);
                      if (pickedDate != null) {
                        dob.text = "${pickedDate!.day.toString()}-${pickedDate!.month.toString()}-${pickedDate!.year.toString()}";
                      } else {
                        dob.text = "Please Select a date";
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  DateTime currentDate = DateTime.now();
                  Age? age = calculateAge(DateTime.now());
                  if (pickedDate != null) {
                    age = calculateAge(pickedDate!);
                  }

                  setState(() {
                    if (pickedDate != null) {
                      calculatedDate = "${age?.year} Years ${age?.month} Month ${age?.days} Days";
                    } else {
                      calculatedDate = "Select a date to find age";
                    }
                  });
                },
                child: const Text("Calculate"),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Age: $calculatedDate",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
