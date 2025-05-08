// ignore_for_file: non_constant_identifier_names

class MyCoursesList {
  final int course_id;
  final int enroll_id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String course_status;
  final int percentage;
  final String certificate_file;
  //final String tag_name;
  final String tag_data;

  MyCoursesList({
    required this.course_id,
    required this.enroll_id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.tag_data,
    required this.course_status,
    required this.percentage,
    required this.certificate_file
  });

  factory MyCoursesList.fromJson(Map<String, dynamic> json) => MyCoursesList(
      course_id: int.parse(json["results"]["course_id"] as String),
      name: json["results"]["name"] as String,
      description: json["results"]["description"] as String,
      price: json["results"]["price"] as String,
      duration: json["results"]["duration"] as String,
      image: json["results"]["image"] as String,
      tag_data: json["results"]["tag_data"] as String,
      enroll_id: int.parse(json["results"]["enroll_id"]as String),
      course_status: json["results"]["course_status"] as String,
      percentage: int.parse(json["results"]["percentage"] as String),
      certificate_file: json["results"]["certificate_file"] as String
  );
}