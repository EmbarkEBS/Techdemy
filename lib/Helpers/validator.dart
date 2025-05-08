class FieldValidator{
  static String? validateFullname(String value){
    if(value.isEmpty)return 'Please Enter Name';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value)) {
      return 'Enter a Valid Fullname!';
    } else {
      return null;
    }
  }
  static String? validateEmail(String value){
    if(value.isEmpty)return 'Please Enter Email!';
    final RegExp regex =
    RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value)) {
      return 'Enter a Valid Email!';
    } else {
      return null;
    }
  }
  static String? validateMobile(String value){
    if(value.isEmpty)return 'Please Enter Mobile Number';
    final RegExp regex=
    RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if(!regex.hasMatch(value)) {
      return 'Enter a Valid Mobile Number!';
    } else {
      return null;
    }
  }
  static String? validateCollegeName(String value){
    if(value.isEmpty)return 'Please Enter College Name';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value)) {
      return 'Enter a Valid College Name!';
    } else {
      return null;
    }
  }

  static String? validateDepartment(String value){
    if(value.isEmpty)return 'Please Enter College Department';
    final RegExp regex=
    RegExp(r'^[a-z A-Z,.\-]+$');
    if(!regex.hasMatch(value)) {
      return 'Enter a Valid Department!';
    } else {
      return null;
    }
  }
}