import 'package:dhyanin_app/screens/pages/otp_page.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileNumberInput extends StatefulWidget {
  const MobileNumberInput({super.key});

  @override
  State<MobileNumberInput> createState() => _MobileNumberInputState();
}

class _MobileNumberInputState extends State<MobileNumberInput> {
  final countryCodeController =
      TextEditingController(); // controller for country code
  var phone = ""; //phone number will be stored in this
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    countryCodeController.text = '+91';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
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
                    style: textStyle_heading,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset(
                  'assets/images/authimage2.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  width: double.infinity,
                  child: const Text(
                    'Phone Number Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  width: double.infinity,
                  child: const Text(
                    'We will send a code (via SMS text message) to your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryCodeController,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("|",
                          style:
                              TextStyle(fontSize: 33, color: Colors.black54)),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            phone = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
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
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countryCodeController.text + phone}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtpPage()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text('Send the code'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: color_2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
