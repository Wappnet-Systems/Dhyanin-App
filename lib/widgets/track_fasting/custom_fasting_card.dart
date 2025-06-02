import 'package:flutter/material.dart';

class FastingCard extends StatelessWidget {
  final String title;
  final bool isStarted;
  final String fastingDateTime;

  const FastingCard(
      {super.key,
      required this.title,
      required this.isStarted,
      required this.fastingDateTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width / 2.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            isStarted
                ? Text(
                    fastingDateTime,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                : Text('---'),
          ],
        ),
      ),
    );
  }
}
