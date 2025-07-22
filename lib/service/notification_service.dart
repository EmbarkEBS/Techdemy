import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final _storage = const FlutterSecureStorage();
  Future<void> notificationPermission() async {
    await Permission.notification.request();
    await Permission.sms.request();
  }

  Future<void> listenForSms() async {
    await SmsAutoFill().listenForCode();
  }

  Future<String> apphash() async {
    if(!await _storage.containsKey(key: "appHash") ){
      String? hash = await SmsAutoFill().getAppSignature;
      await _storage.write(key: "appHash", value: hash);
      return hash;
    } else {
      return await _storage.read(key: "appHash") ?? "";
    }
  }
 
  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    // await storeOtp(otp.toString());
    return otp;
  }

  Future<void> storeOtp(String otp) async{
   await _storage.write(key: "lastOtp", value:otp);
  }

  Future<void> clearOTP() async{
    await _storage.delete(key: "lastOtp");
  }

  Future<String?> getLastOtp() async {
    return await _storage.read(key: "lastOtp") ?? "";
  }

  Future<void> twilioOTPSender(String mobile) async {
    try {
      await SmsAutoFill().listenForCode();
      int? lastOtp = await generateOTP();
      String hashId = await apphash();
      String key = "f665fb10246333b640a6f6bd929e2af3";
      String receiver = mobile;
      String templateId= "1407168862906996721";
      String sms = "Your otp for Maduraimarket is $lastOtp. Please do not share this OTP. $hashId";
      String url = "http://instantalerts.in/api/smsapi?key=$key&route=2&sender=INSTNE&number=$receiver&templateid=$templateId&sms=$sms";
      final response = await http.post(Uri.parse(url),);
      if (response.statusCode == 200) {
        debugPrint("OTP sent successfully from $receiver");
      } else {
        debugPrint("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error sending OTP: $e");
    }
  }
}