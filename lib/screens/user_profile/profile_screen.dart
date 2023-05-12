import 'dart:io';

import 'package:dhyanin_app/screens/home_screen.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Exit App'),
                content: Text('Do you want to exit?'),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      exit(0);
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
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: primaryColor,
            elevation: 0,
            title: Text(
              "Profile",
              style: TextStyle(color: backgroundColor),
            ),
          ),
          body: Center(
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
                        maxLength: 15,
                        decoration: InputDecoration(
                            hintText: "Your First Name",
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            labelText: "Name",
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            // contentPadding: EdgeInsets.all(10.0),
                            prefixIcon: Icon(
                              Icons.person,
                              color: primaryColor,
                              size: 35,
                            )),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: emailValidator,
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "Your Email",
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            // contentPadding: EdgeInsets.all(10.0),
                            prefixIcon: Icon(
                              Icons.email,
                              color: primaryColor,
                              size: 28,
                            )),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await saveProfile();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: ((context) => HomeScreen())));
                            }
                          },
                          child: Text('Submit'))
                    ],
                  )),
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
