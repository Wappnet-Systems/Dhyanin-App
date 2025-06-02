import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/controller/history_controller.dart';
import '../../services/controller/meditation_history_controller.dart';
import '../../services/models/history_model.dart';
import '../../services/models/meditation_history_model.dart';
import '../../services/providers/colors_theme_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/breath_meditation/meditation_history_item.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/track_fasting/history_item.dart';

class PastHistoryScreen extends StatefulWidget {
  const PastHistoryScreen({Key? key}) : super(key: key);

  @override
  _PastHistoryScreenState createState() => _PastHistoryScreenState();
}

class _PastHistoryScreenState extends State<PastHistoryScreen> {
  HistoryController historyController = HistoryController();
  MeditationHistoryController mHistoryController =
      MeditationHistoryController();
  List<MeditationHistory> meditationHistory = [];
  List<History> fastHistory = [];
  List<MeditationHistoryItem> meditationItems = [];
  List<HistoryItem> fastingItems = [];
  DateTime _selectedDate = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  DateTime endOfWeek = DateTime.now();
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    _updateWeekRange();
    super.initState();
    fetchFastingHistoryData();
    fetchMeditationHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return DefaultTabController(
        length: 2,
        child: Container(
          decoration: topLeftToBottomRightGradient(model),
          child: Scaffold(
            appBar: CustomAppBar(title: 'History'),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _goToPreviousWeek,
                    ),
                    Text(
                      _getFormattedWeekRange(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _goToNextWeek,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.095,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7, // Number of weeks to display
                      itemBuilder: (context, index) {
                        final weekStartDate =
                            startOfWeek.add(Duration(days: index));
                        final date = weekStartDate.day;
                        final weekDay = _getWeekdayName(weekStartDate.weekday);
                        String formattedSelectedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDateTime);
                        String formattedWeekStartDate =
                            DateFormat('yyyy-MM-dd').format(weekStartDate);
                        if (formattedSelectedDate == formattedWeekStartDate)
                          selectedDateTime = weekStartDate;
                        return GestureDetector(
                          onTap: () {
                            if (weekStartDate.isBefore(DateTime.now())) {
                              setState(() {
                                selectedDateTime = weekStartDate;
                              });
                              filteredFastingHistoryData();
                              filteredMeditationHistoryData();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 7.7,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: weekStartDate.isAfter(DateTime.now())
                                      ? Colors.grey
                                      : selectedDateTime == weekStartDate
                                          ? model.primaryColor
                                          : Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.transparent,
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      weekStartDate.isAfter(DateTime.now())
                                          ? Colors.grey
                                          : selectedDateTime == weekStartDate
                                              ? model.primaryColor
                                              : model.backgroundColor,
                                      weekStartDate.isAfter(DateTime.now())
                                          ? Colors.grey
                                          : selectedDateTime == weekStartDate
                                              ? model.secondaryColor2
                                              : model.backgroundColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      date.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 25,
                                        color: weekStartDate
                                                .isAfter(DateTime.now())
                                            ? Colors.white
                                            : selectedDateTime == weekStartDate
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      weekDay,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: weekStartDate
                                                .isAfter(DateTime.now())
                                            ? Colors.white
                                            : selectedDateTime == weekStartDate
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TabBar(
                  indicator: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(20),
                    color: model.primaryColor,
                  ),
                  tabs: [
                    Tab(
                      text: 'Meditation History',
                    ),
                    Tab(
                      text: 'Fasting History',
                    )
                  ],
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.white,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.separated(
                        itemBuilder: (context, index) {
                          return meditationItems[index];
                        },
                        itemCount: meditationItems.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                      ),
                      ListView.separated(
                        itemBuilder: (context, index) {
                          return fastingItems[index];
                        },
                        itemCount: fastingItems.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          thickness: 0,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void fetchMeditationHistoryData() async {
    meditationHistory = await mHistoryController.read();
    meditationHistory.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });
    setState(() {
      meditationItems = meditationHistory
          .where((item) {
            final itemDate = item.dateTime;
            return itemDate.isAfter(startOfWeek) &&
                itemDate.isBefore(endOfWeek);
          })
          .map((item) => MeditationHistoryItem(
                history: item,
                isNewDay:
                    false, // Assuming you don't need to check for new day in the filtered list
              ))
          .toList();
      filteredMeditationHistoryData();
    });
  }

  void fetchFastingHistoryData() async {
    fastHistory = await historyController.read();
    fastHistory.sort((a, b) {
      return b.dateTime.compareTo(a.dateTime);
    });
    setState(() {
      fastingItems = fastHistory
          .where((item) {
            final itemDate = item.dateTime;
            return itemDate.isAfter(startOfWeek) &&
                itemDate.isBefore(endOfWeek);
          })
          .map((item) => HistoryItem(
                history: item,
                isNewDay:
                    false, // Assuming you don't need to check for new day in the filtered list
              ))
          .toList();
      filteredFastingHistoryData();
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 7));
      _updateWeekRange();
    });
  }

  void _goToNextWeek() {
    if (_selectedDate.isBefore(DateTime.now().add(Duration(days: -7)))) {
      setState(() {
        _selectedDate = _selectedDate.add(Duration(days: 7));
        _updateWeekRange();
      });
    }
  }

  String _getFormattedWeekRange() {
    final formatter = DateFormat('dd MMM');
    startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    endOfWeek = _selectedDate
        .add(Duration(days: DateTime.daysPerWeek - _selectedDate.weekday));
    return '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';
  }

  void filteredMeditationHistoryData() async {
    setState(() {
      // Update the filteredMeditationItems list based on the selected date
      meditationItems = meditationHistory
          .where((item) =>
              item.dateTime.year == selectedDateTime.year &&
              item.dateTime.month == selectedDateTime.month &&
              item.dateTime.day == selectedDateTime.day)
          .map((item) => MeditationHistoryItem(
                history: item,
                isNewDay: false,
              ))
          .toList();
    });
  }

  void filteredFastingHistoryData() async {
    setState(() {
      // Update the filteredFastingItems list based on the selected date
      fastingItems = fastHistory
          .where((item) =>
              item.dateTime.year == selectedDateTime.year &&
              item.dateTime.month == selectedDateTime.month &&
              item.dateTime.day == selectedDateTime.day)
          .map((item) => HistoryItem(
                history: item,
                isNewDay: false,
              ))
          .toList();
    });
  }

  // Update the startOfWeek and endOfWeek variables
  void _updateWeekRange() {
    startOfWeek =
        _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    endOfWeek = _selectedDate
        .add(Duration(days: DateTime.daysPerWeek - _selectedDate.weekday));
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
