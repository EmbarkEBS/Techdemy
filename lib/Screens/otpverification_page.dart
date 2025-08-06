import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tech/controllers/auth_controller.dart';

class OTPVerificationPage extends StatefulWidget {
  final String? mobileNumber;
  const OTPVerificationPage({super.key, this.mobileNumber});

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
    SmsAutoFill().getAppSignature.then((value) {
      debugPrint("😊 App Signature: $value");
    });
  }

  @override
  void codeUpdated() async {
    if (!mounted) return;
    setState(() {
      _otpController.text = code!;
      _code = code!;
    });
    final controller = Get.find<AuthController>();
    final mobile = Get.arguments;
    await controller.checkOtp(_code, mobile);
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;
    final mobile = Get.arguments;
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
                    image: const AssetImage("assets/images/techdemy_logo.png",)
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    "Enter the verification code sent to your Mobile number",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0,),
                  ),
                  const SizedBox(height: 10,),
                   PinFieldAutoFill(
                    codeLength: 4,
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder: FixedColorBuilder(Colors.black.withValues(alpha: 0.3)),
                    ),
                    currentCode: _code,
                  ),
                  const SizedBox(height: 20,),
                  GetBuilder<AuthController>(
                    id: "verifyOtp",
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
                          await controller.checkOtp(_otpController.text, mobile ?? "");
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
                  GetBuilder<AuthController>(
                    id: "resend",
                    builder: (btncontroller) {
                      return btncontroller.isResending
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : TextButton(
                        onPressed:() async {
                          // await controller.verifyUser();
                          await btncontroller.resendOtp(mobile ?? "");
                        },
                        child: const Text("Resend OTP", style: TextStyle(color: Colors.black),),
                      );
                    }
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
