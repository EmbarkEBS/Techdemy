import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tech/controllers/auth_controller.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {

  final _formkey_2 = GlobalKey<FormState>();
  String _code = "";

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
                    "Enter the verification code sent to your mail-id",
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
                    onCodeChanged: (code) async {
                      if (code!.length == 4) {
                        setState(() {
                          _code = code;
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      try {
                        // await controller.verifyOtp(_code);
                      } catch (e) {
                        // print("Error occured: $e");
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  FilledButton(
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
                      Navigator.pushReplacementNamed(context, '/homepage');
                     if (!_formkey_2.currentState!.validate()) {
                        await controller.verifyOtp(_code);
                     }
                    },
                    child: const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    onPressed: () async {
                      await controller.resendOtp();
                    },
                    child: const Text("Resend OTP"),
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

  // TextEditingController contrller1 = TextEditingController();
  // TextEditingController contrller2 = TextEditingController();
  // TextEditingController contrller3 = TextEditingController();
  // TextEditingController contrller4 = TextEditingController();
  // TextEditingController contrller5 = TextEditingController();
  // TextEditingController contrller6 = TextEditingController();

  // Widget _textFieldOTP({bool? first, last, TextEditingController? controllerr}) {
  //   double height = MediaQuery.of(context).size.height;
  //   double width = MediaQuery.of(context).size.width;
  //   return SizedBox(
  //     height: width > 600 ? 55 : height / 12,
  //     child: AspectRatio(
  //       aspectRatio: 1.0,
  //       child: TextFormField(
  //         controller: controllerr,
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Enter Valid OTP';
  //           }
  //           return null;
  //         },
  //         autofocus: true,
  //         onChanged: (value) {
  //           if (value.length == 1 && last == false) {
  //             FocusScope.of(context).nextFocus();
  //           }
  //           if (value.isEmpty && first == false) {
  //             FocusScope.of(context).previousFocus();
  //           }
  //         },
  //         showCursor: false,
  //         readOnly: false,
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         keyboardType: TextInputType.number,
  //         maxLength: 1,
  //         decoration: InputDecoration(
  //           counter: const Offstage(),
  //           enabledBorder: OutlineInputBorder(
  //             borderSide: const BorderSide(width: 2, color: Colors.black54),
  //             borderRadius: BorderRadius.circular(5)
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: const BorderSide(width: 2, color: Colors.blue),
  //             borderRadius: BorderRadius.circular(5)
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }