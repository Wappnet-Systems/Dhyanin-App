import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class WeekDayCard extends StatelessWidget {
  int date;
  String weekDay;
  WeekDayCard({super.key, required this.date, required this.weekDay});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.095,
      width: MediaQuery.of(context).size.width / 7.7,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: DateTime.now().day != date
                // ? primary_color.withOpacity(0.3)
                ? Colors.white
                : primary_color,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: DateTime.now().day == date ? primary_color : background_color,
        elevation: 4,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(date.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 25,
                    color: DateTime.now().day == date
                        ? Colors.white
                        : Colors.black)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              weekDay,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color:
                      DateTime.now().day == date ? Colors.white : Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
