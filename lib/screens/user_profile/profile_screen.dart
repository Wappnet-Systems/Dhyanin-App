import 'dart:io';

import 'package:dhyanin_app/screens/home_screen.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/providers/colors_theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorsModel.backgroundColor,
            colorsModel.secondaryColor2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
          // backgroundColor: Theme.of(context).colorScheme.background,
          appBar: CustomAppBar(title: "Profile"),
          body: Consumer<ColorsThemeNotifier>(
            builder: (context, themeModel, child) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: nameController.text.isEmpty
                              ? Text(
                                  "Enter Your Profile Info.",
                                  style: TextStyle(fontSize: 25),
                                )
                              : Text('Edit Your Profile Info'),
                        ),
                        TextFormField(
                          controller: nameController,
                          maxLength: 12,
                          decoration: InputDecoration(
                              hintText: "Your First Name",
                              labelText: "Name",
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              // contentPadding: EdgeInsets.all(10.0),
                              prefixIcon: Icon(
                                Icons.person,
                                color: themeModel.secondaryColor2,
                                size: 35,
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: emailValidator,
                          maxLength: 25,
                          decoration: InputDecoration(
                              hintText: "Your Email",
                              labelText: "Email",
                              labelStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              // contentPadding: EdgeInsets.all(10.0),
                              prefixIcon: Icon(
                                Icons.email,
                                color: themeModel.secondaryColor2,
                                size: 28,
                              )),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: themeModel.secondaryColor2),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await saveProfile();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) => HomeScreen())));
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )),
              ),
            ),
          )),
    );
  }

  //email validator
  String? emailValidator(String? value) {
    String pattern =
        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
    RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  //get name and email from prefs
  Future<bool> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = await prefs.getString('name').toString();
    emailController.text = await prefs.getString('email').toString();
    if (nameController.text.isEmpty) return false;
    return true;
  }

  //save name and email to prefs
  Future<void> saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
  }
}
