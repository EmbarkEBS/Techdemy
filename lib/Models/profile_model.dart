class ProfileModel {
  final String id;
  final String name;
  final String gender;
  final String address;
  final String email;
  final String mobile;
  final String usercategory;
  final String collegename;
  final String department;
  final String studentyear;
  final String experiencelevel;

  ProfileModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.address,
    required this.email,
    required this.mobile,
    required this.usercategory,
    required this.collegename,
    required this.department,
    required this.studentyear,
    required this.experiencelevel,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["appuser_id"] ?? 0, 
      name: json["name"] ?? "", 
      gender: json["gender"] ?? "", 
      address: json["address"] ?? "",
      email: json["email"] ?? "", 
      mobile: json["phone_no"] ?? "", 
      usercategory: json["user_category"] ?? "", 
      collegename: json["college_name"] ?? "", 
      department: json["department"] ?? "", 
      studentyear: json["year"] ?? "", 
      experiencelevel: json["exp_level"] ?? ""
    );
  }
  
}