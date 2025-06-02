import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/providers/colors_theme_provider.dart';

class MyCard extends StatefulWidget {
  final String image_path;
  final String title;
  final String subTitle;
  final Widget next_page;
  const MyCard(
      {super.key,
      required this.image_path,
      required this.title,
      required this.subTitle,
      required this.next_page});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  var _currentOpacity = 1.0;
  var _isVisible = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {});
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer.cancel(); // Cancel the previous timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => widget.next_page)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: colorsModel.primaryColor, width: 0.3),
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: FractionalOffset.centerLeft,
                end: FractionalOffset.center,
                colors: [
                  colorsModel.primaryColor,
                  colorsModel.secondaryColor1,
                ],
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(widget.image_path,
                              fit: BoxFit.cover)),
                    ),
                    Container(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Container(height: 5),
                          Text(
                            widget.subTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontFamily: "",
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _isVisible ? _currentOpacity : 0.0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      color: colorsModel.secondaryColor2,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Get Started Now!',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
