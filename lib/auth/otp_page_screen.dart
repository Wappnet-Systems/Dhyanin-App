import 'package:dhyanin_app/auth/mobile_number_input_screen.dart';
import 'package:dhyanin_app/screens/user_profile/profile_screen.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/images.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/widgets/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

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
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    //design themes for OTP pinput
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: model.secondaryColor2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: model.secondaryColor1,
      ),
    );
    return Container(
      decoration: topLeftToBottomRightGradient(model),
      child: Scaffold(
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
        // backgroundColor: backgroundColor,
        body: Consumer<ColorsThemeNotifier>(
          builder: (context, themeModel, child) => SafeArea(
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
                        'Enter OTP which we have sent (via SMS text message) to your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
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
                                    builder: (context) => ProfileScreen()));
                          } catch (e) {
                            CustomSnackbar.functionSnackbar(
                                context, "Wrong OTP!");
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: loading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: themeModel.backgroundColor,
                              ))
                            : Text(
                                'Verify phone number',
                                style: TextStyle(color: Colors.white),
                              ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeModel.secondaryColor2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
