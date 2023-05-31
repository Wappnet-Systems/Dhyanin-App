import 'dart:io';
import 'dart:typed_data';

import 'package:dhyanin_app/screens/custom_images/custom_background_images.dart';
import 'package:dhyanin_app/screens/past_history/past_history_screen.dart';
import 'package:dhyanin_app/screens/user_profile/profile_screen.dart';
import 'package:dhyanin_app/services/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/mobile_number_input_screen.dart';
import 'color_circle.dart';

List<String> savedImagePaths = [];

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
              Navigator.of(context).pop();
              Navigator.of(context).push(
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
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomBackgroundImages()));
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Text(
                    'Custom Images',
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
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PastHistoryScreen()));
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  Text(
                    'History',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Icon(
                    Icons.history,
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
            tilePadding: EdgeInsets.only(left: 0, right: 15),
            title: Text(
              'Change Theme',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.025,
                  ),
                  ColorCircle(Color(0xFFF06292), 1),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Color(0xFF4DB6AC), 2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Color(0xFF81C784), 3),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Color(0xFF64B5F6), 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                  ColorCircle(Color(0xFF9575CD), 5),
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('name', "");
                prefs.setString('email', "");
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
