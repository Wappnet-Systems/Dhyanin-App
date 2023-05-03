import 'package:dhyanin_app/screens/pages/home_screen.dart';
import 'package:dhyanin_app/screens/auth/mobile_number_input_screen.dart';
import 'package:dhyanin_app/screens/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../utils/colors.dart';
import '../../utils/constant.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance; //firebase instance
  var code = ""; //to store code entered by user
  bool loading = false; // to show loading indicator
  @override
  Widget build(BuildContext context) {
    //design themes for OTP pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: color_2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromARGB(255, 234, 134, 181),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            )),
      ),
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
                    style: headingStyle,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Image.asset(
                  'assets/images/registration.png',
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
                    'Enter OTP which we have sent (via SMS text message) to your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Pinput(
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    code = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: MobileNumberInput.verify,
                                smsCode: code);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      } catch (e) {
                        CustomSnackbar.functionSnackbar(context, "Wrong OTP!");
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: background_color,
                          ))
                        : Text('Verify phone number'),
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
