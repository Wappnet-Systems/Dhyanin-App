import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final String name;
  final Widget next_page;
  const SimpleCard({super.key, required this.name, required this.next_page});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => next_page)),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.only(left: 5.0, right: 20.0, top: 5.0),
            child: Container(
              height: 55.0,
              width: 140.0,
              decoration: BoxDecoration(
                  color: primary_color.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow,
                      size: 40, color: background_color),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
