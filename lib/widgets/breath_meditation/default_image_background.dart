import 'package:flutter/material.dart';

class DefaultImage extends StatefulWidget {
  final String imagePath;
  final Function ontap;
  DefaultImage({super.key, required this.imagePath, required this.ontap});

  @override
  State<DefaultImage> createState() => _DefaultImageState();
}

class _DefaultImageState extends State<DefaultImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          widget.ontap();
        },
        child: Image.asset(
          widget.imagePath,
          height: MediaQuery.of(context).size.height * 0.2,
        ),
      ),
    );
  }
}
