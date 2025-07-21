class CourseList {
  final int courseId;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String tagData;

  CourseList({
    required this.courseId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.duration,
    required this.tagData,
  });

  factory CourseList.fromJson(Map<String, dynamic> json) {
    return CourseList(
      courseId: int.parse(json["course_id"].toString()),
      name: json["name"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      duration: json["duration"],
      tagData: json["tag_data"] ?? "",
      // courseMaterial: json['course_material']
    );
  }
}
