import 'package:dhyanin_app/services/models/meditation_history_model.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/controller/meditation_history_controller.dart';
import '../../services/providers/colors_theme_provider.dart';
import '../../utils/images.dart';
import '../../widgets/breath_meditation/meditation_history_item.dart';
import '../../widgets/custom_app_bar.dart';

class MeditationHistoryScreen extends StatefulWidget {
  const MeditationHistoryScreen({super.key});

  @override
  State<MeditationHistoryScreen> createState() =>
      _MeditationHistoryScreenState();
}

class _MeditationHistoryScreenState extends State<MeditationHistoryScreen> {
  MeditationHistoryController historyController = MeditationHistoryController();
  List<MeditationHistory> listHistory = [];
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
    super.initState();
    fetchHistoryData();
  }

  void fetchHistoryData() async {
    listHistory = await historyController.read();
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
        appBar: CustomAppBar(title: 'Meditation History'),
        body: listHistory.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottiePath, width: 250),
                    Text(
                      'You don\'t have any meditation added yet!',
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
                    return MeditationHistoryItem(
                      history: item,
                      isNewDay: false,
                    );
                  } else {
                    return MeditationHistoryItem(
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
