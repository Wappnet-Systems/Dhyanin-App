import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyCard extends StatelessWidget {
  final String image_path;
  final String name;
  final Widget next_page;
  const MyCard(
      {super.key,
      required this.image_path,
      required this.name,
      required this.next_page});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => next_page)),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
              color: background_color,
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(image_path))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      ),
    );
  }
}
