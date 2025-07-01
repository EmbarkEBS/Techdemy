import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tech/controllers/auth_controller.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> with CodeAutoFill{

  final _formkey_2 = GlobalKey<FormState>();
  String _code = "";
  final TextEditingController _otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpController.text = code!;
    });
    // TODO verify the OTP and navigate to home screen
  }

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formkey_2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20,),
                  Image(
                    //width: 180,
                    //height: 230,
                    height: size.height * 0.2,
                    image: const AssetImage("assets/images/Techdemy_logo1.png",)
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    "Enter the verification code sent to your Mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0,),
                  ),
                  const SizedBox(height: 10,),
                  PinFieldAutoFill(
                    controller: _otpController,
                    codeLength: 4,
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder: FixedColorBuilder(Colors.black.withValues(alpha: 0.3)),
                    ),
                    currentCode: _code,
                    onCodeChanged: (code) async {
                      if (code!.length == 4) {
                        _code = code;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      // TODO: Verfiy OTP with backend
                      try {
                        // await controller.verifyOtp(_code);
                      } catch (e) {
                        // print("Error occured: $e");
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  GetBuilder<AuthController>(
                    builder: (ctr) {
                      return FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: Colors.black)
                          ),
                          minimumSize: const Size(double.infinity, 50)
                        ),
                        onPressed: () async {
                          Navigator.pushNamedAndRemoveUntil(context, '/homepage', (route) => false,);
                        //  if (!_formkey_2.currentState!.validate()) {
                        //     await controller.verifyOtp(_code);
                        //  }
                        },
                        child: ctr.isVerifying
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.yellow,
                              ),
                            ),
                          )
                        : const Text('Verify OTP', style: TextStyle(color: Colors.yellow)),
                      );
                    }
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    onPressed: () async {
                      await controller.resendOtp();
                    },
                    child: const Text("Resend OTP",),
                  )
                ],
              ),
            )
          ),
        ),
      )
    );
  }
  
 

}