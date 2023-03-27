import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final String name;
  final Widget next_page;
  const SimpleCard({super.key, required this.name, required this.next_page});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => next_page)),
      child: Card(
        margin: EdgeInsets.only(left: 5.0, right: 20.0, top: 5.0),
        child: Container(
          height: 70.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: primary_color, borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            children: [
              const Icon(Icons.play_arrow, size: 50, color: background_color),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.arrow_forward,
                  size: 40,
                  color: background_color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
