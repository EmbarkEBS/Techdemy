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
  final int courseId;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String tagData;
  final String courseMaterial;

  CourseDetailPart({
    required this.courseId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.tagData,
    required this.courseMaterial
  });
  factory CourseDetailPart.fromJson(Map<String, dynamic> json) {
    return CourseDetailPart(
      courseId: json['course_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? '',
      image: json['image'] ?? '',
      tagData: json['tag_data'] ?? '',
      courseMaterial: json['course_material'] ?? ''
    );
  }
 
}

class ChapterDataPart {
  final int chapterId;
  final String chapterName;
  final String topicData;
  final int quizLimit;
  final int quizCount;
  final int topicCount;
  final int timer;

  ChapterDataPart({
    required this.chapterId,
    required this.chapterName,
    required this.topicData,
    required this.timer,
    required this.quizLimit,
    required this.quizCount,
    required this.topicCount,
  });
  factory ChapterDataPart.fromJson(Map<String, dynamic> json) {
    return ChapterDataPart(
      chapterId: json['chapter_id'] ?? 0,
      chapterName: json['chapter_name'] ?? "",
      topicData: json['topic_data'] ?? "",
      timer: int.tryParse(json["quiz_time"]) ?? 10,
      quizLimit: int.tryParse(json["quiz_limit"] ?? "3") ?? 3,
      quizCount: json["no_of_quiz"] ?? 0,
      topicCount: json["no_of_topics"] ?? 0,
    );
  }
}
