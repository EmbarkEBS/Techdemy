// ignore_for_file: non_constant_identifier_names

class CourseDetail{
  final CourseDetailPart courseDetailPart;
  final List<ChapterDataPart> chapters;

  CourseDetail({
    required this.courseDetailPart,
    required this.chapters,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      courseDetailPart: CourseDetailPart.fromJson(json["results"]), 
      chapters: (json["chapter_data"] as List<dynamic>)
        .map((chapter) => ChapterDataPart.fromJson(chapter),)
        .toList()
    );
  }
}

class CourseDetailPart {
  final int course_id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String tag_data;
  final String courseMaterial;
  //final List<ChapterData> chapter_data;

  CourseDetailPart({
    required this.course_id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.tag_data,
    required this.courseMaterial
    //required this.chapter_data,
    // required this.chapter_id,
    // required this.chapter_name,
    // required this.topic_data,
  });
  factory CourseDetailPart.fromJson(Map<String, dynamic> json) {
    return CourseDetailPart(
      course_id: json['course_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? '',
      image: json['image'] ?? '',
      tag_data: json['tag_data'] ?? '',
      courseMaterial: json['course_material'] ?? ''
    );
  }
 
}

class ChapterDataPart {
  final int chapter_id;
  final String chapter_name;
  final String topic_data;

  ChapterDataPart({
    required this.chapter_id,
    required this.chapter_name,
    required this.topic_data,
  });
  factory ChapterDataPart.fromJson(Map<String, dynamic> json) {
    return ChapterDataPart(
      chapter_id: json['chapter_id'],
      chapter_name: json['chapter_name'],
      topic_data: json['topic_data'],
    );
  }
}
