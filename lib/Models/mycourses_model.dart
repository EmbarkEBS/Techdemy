class MyCoursesList {
  final String courseId;
  final String enrollId;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String courseStatus;
  final String percentage;
  final String certificateFile;
  final String tagData;

  MyCoursesList({
    required this.courseId,
    required this.enrollId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.tagData,
    required this.courseStatus,
    required this.percentage,
    required this.certificateFile
  });

  factory MyCoursesList.fromJson(Map<String, dynamic> json) => MyCoursesList(
      courseId: (json["course_id"] ?? "0").toString(),
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"].toString()),
      duration: json["duration"] ?? "",
      image: json["image"] ?? "",
      tagData: json["tag_data"] ?? "",
      enrollId: (json["enroll_id"] ?? "0").toString(),
      courseStatus: json["course_status"] ?? "",
      percentage: (json["percentage"] ?? "0").toString(),
      certificateFile: json["certificate_file"] ?? ""
  );
}