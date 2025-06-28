import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  
  Future<void> notificationPermission() async {
    await Permission.notification.request();
    await Permission.sms.request();
  }

  Future<void> listenForSms() async {
    await SmsAutoFill().listenForCode();
  }

  Future<String> apphash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("app_hash") == null){
      String? hash = await SmsAutoFill().getAppSignature;
      await prefs.setString("app_hash", hash);
      return hash;
    } else {
      return prefs.getString("app_hash")!;
    }
  }
 
  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    // await storeOtp(otp.toString());
    return otp;
  }

  Future<void> storeOtp(String otp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString("last_otp", otp);
  }

  Future<void> clearOTP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("last_otp");
  }

  Future<String?> getLastOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("last_otp");
  }

  // TODO: Check the code API once credits are restored and call this in login button
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
        print("OTP sent successfully from $receiver");
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }
}