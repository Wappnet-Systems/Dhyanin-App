import 'package:dhyanin_app/screens/user_profile/profile_screen.dart';
import 'package:dhyanin_app/services/functions/select_theme.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/services/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/mobile_number_input_screen.dart';
import '../utils/colors.dart';

Widget MyDrawerList(BuildContext context) {
  ThemeManagerProvider model =
      Provider.of<ThemeManagerProvider>(context, listen: true);
  return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          Divider(thickness: 0.5),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 0.5),
          InkWell(
            onTap: () {},
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Text(
                    'Add Custom Images',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 0.5),
          Row(
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Switch(
                  value: model.isDark,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    model.changeTheme();
                  })
            ],
          ),
          Divider(thickness: 0.5),
          ExpansionTile(
            title: Text(
              'Change Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.025,
                  ),
                  ColorCircle(Color(0xffDE0CA3), 1),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Colors.red, 2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Colors.green, 3),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Colors.blue, 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Colors.purple, 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          Divider(thickness: 0.5),
          InkWell(
            onTap: () {
              signOut(context);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 0.5),
        ],
      ));
}

class ColorCircle extends StatelessWidget {
  final Color color;
  final int themeIndex;
  ColorCircle(this.color, this.themeIndex);

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return InkWell(
      onTap: () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setInt('theme', themeIndex);
        selectTheme(themeIndex);
        colorsModel.selectTheme(themeIndex);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
          color: color,
        ),
      ),
    );
  }
}

Future<void> signOut(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MobileNumberInput()));
              },
              child: Text("Yes"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.end,
        );
      });
}
