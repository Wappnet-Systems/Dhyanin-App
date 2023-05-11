import 'dart:io';

import 'package:dhyanin_app/auth/otp_page_screen.dart';
import 'package:dhyanin_app/utils/images.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/services/functions/check_connectivity.dart';
import 'package:dhyanin_app/widgets/custom_snackbar.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MobileNumberInput extends StatefulWidget {
  const MobileNumberInput({super.key});

  static String verify = ""; //to store OTP coming from firebase

  @override
  State<MobileNumberInput> createState() => _MobileNumberInputState();
}

class _MobileNumberInputState extends State<MobileNumberInput> {
  final countryCodeController =
      TextEditingController(); // controller for country code
  var phone = ""; //phone number will be stored in this
  final auth = FirebaseAuth.instance; //firebase instance
  bool loading = false; //to show loading indicator to user

  @override
  void initState() {
    CheckInternetConnectivity();
    countryCodeController.text = '+91'; //default country code for india
    super.initState();
  }

  //input formatter for prefix of mobile number
  var prefixFormatter = new MaskTextInputFormatter(
      mask: '+###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  //input formatter for mobile number input
  var mobileNumberFormatter = new MaskTextInputFormatter(
      mask: '##### #####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Exit App'),
                  content: const Text('Do you want to exit?'),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: const Text("Yes"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("No"),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.end,
                );
              });
          return true;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 22.0),
                      width: double.infinity,
                      child: const Text(
                        'Registration',
                        textAlign: TextAlign.center,
                        style: headingStyle,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Image.asset(
                      registrationImage,
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40.0),
                      width: double.infinity,
                      child: const Text(
                        'Phone Number Verification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      width: double.infinity,
                      child: const Text(
                        'We will send a code (via SMS text message) to your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 40,
                            child: TextField(
                              inputFormatters: [prefixFormatter],
                              keyboardType: TextInputType.phone,
                              controller: countryCodeController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("|",
                              style: TextStyle(
                                  fontSize: 33, color: Colors.black54)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              inputFormatters: [mobileNumberFormatter],
                              onChanged: (value) {
                                phone = value;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone number'),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (phone != "" && phone.length > 10) {
                            setState(() {
                              loading = true;
                            });
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: countryCodeController.text + phone,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                CustomSnackbar.functionSnackbar(
                                    context, "Please, enter a valid number!");
                                setState(() {
                                  loading = false;
                                });
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                setState(() {
                                  MobileNumberInput.verify = verificationId;
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const OtpPage()));
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } else {
                            CustomSnackbar.functionSnackbar(
                                context, "Please, enter a valid number!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: backgroundColor,
                              ))
                            : const Text('Send the code'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
