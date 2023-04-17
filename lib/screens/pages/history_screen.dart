import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/models/history_model.dart';
import 'package:dhyanin_app/screens/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/screens/widgets/history_item.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryController historyController = HistoryController();
  List<History> listHistory = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primary_color));
    HistoryController.init();
    listHistory.addAll(historyController.read("history"));
    listHistory.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      appBar: CustomAppBar(title: 'History'),
      body: listHistory.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/empty_list.json', width: 250),
                  Text(
                    'You haven\'t fasted yet!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final item = listHistory.elementAt(index);
                if (index != 0 &&
                    (item.dateTime.day ==
                        listHistory.elementAt(index - 1).dateTime.day) &&
                    (item.dateTime.month ==
                        listHistory.elementAt(index - 1).dateTime.month) &&
                    (item.dateTime.year ==
                        listHistory.elementAt(index - 1).dateTime.year)) {
                  return HistoryItem(
                    history: item,
                    isNewDay: false,
                  );
                } else {
                  return HistoryItem(
                    history: item,
                    isNewDay: true,
                  );
                }
              },
              itemCount: listHistory.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 0,
                color: Colors.transparent,
              ),
            ),
    );
  }
}
