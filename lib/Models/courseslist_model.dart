class CourseList {

  final int course_id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String tag_data;


  CourseList(
      {
        required this.course_id,
        required this.name,
        required this.description,
        required this.image,
        required this.price,
        required this.duration,
        required this.tag_data,
      });

  factory CourseList.fromJson(Map<String, dynamic> json) {
    return CourseList(
      course_id: int.parse(json["course_id"].toString()),
      name: json["name"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      duration: json["duration"],
      tag_data: json["tag_data"],
    );
  }
}

