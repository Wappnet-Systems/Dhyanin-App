import 'package:dhyanin_app/services/controller/history_controller.dart';
import 'package:dhyanin_app/services/models/history_model.dart';
import 'package:dhyanin_app/utils/images.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/widgets/track_fasting/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/providers/colors_theme_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryController historyController = HistoryController();
  List<History> listHistory = [];
  late String lottiePath;
  late ColorsThemeNotifier model;

  @override
  void initState() {
    model = Provider.of<ColorsThemeNotifier>(context, listen: false);
    if (model.primaryColor == Color(0xFFF06292)) {
      lottiePath = emptyHistoryListPink;
    } else if (model.primaryColor == Color(0xFFFF9800)) {
      lottiePath = emptyHistoryListRed;
    } else if (model.primaryColor == Color(0xFF43A047)) {
      lottiePath = emptyHistoryListGreen;
    } else if (model.primaryColor == Color(0xFF536DFE)) {
      lottiePath = emptyHistoryListBlue;
    } else {
      lottiePath = emptyHistoryListPurple;
    }
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: model.primaryColor));
    super.initState();
    fetchHistoryData();
  }

  getHistory() async {
    listHistory = await historyController.read();
  }

  void fetchHistoryData() async {
    await getHistory();
    setState(() {
      listHistory.sort((a, b) {
        return b.dateTime.compareTo(a.dateTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: topLeftToBottomRightGradient(model),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Fast History'),
        body: listHistory.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottiePath, width: 250),
                    Text(
                      'You haven\'t fasted yet!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
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
      ),
    );
  }
}
