class CourseDetail{
  final CourseDetailPart courseDetailPart;
  final List<ChapterDataPart> chapters;
  final BatchDetailModel? batchDetail;

  CourseDetail({
    required this.courseDetailPart,
    required this.chapters,
    required this.batchDetail,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      courseDetailPart: CourseDetailPart.fromJson(json["results"]), 
      chapters: (json["chapter_data"] as List<dynamic>)
        .map((chapter) => ChapterDataPart.fromJson(chapter),)
        .toList(),
      batchDetail: json["batch_data"] != null ? BatchDetailModel.fromJson(json["batch_data"]) : null,
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
  final List<TopicDataPart> topicData;
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
      topicData: ((json['topic_data'] ?? []) as List<dynamic>).map((json) => TopicDataPart.fromJson(json),).toList(),
      timer: int.tryParse(json["quiz_time"]) ?? 10,
      quizLimit: int.tryParse(json["quiz_limit"] ?? "3") ?? 3,
      quizCount: json["no_of_quiz"] ?? 0,
      topicCount: json["no_of_topics"] ?? 0,
    );
  }
}


class TopicDataPart{
  final String topicTitle;
  final String topicDescription;
  final int? readTime;

  TopicDataPart({
    required this.topicTitle,
    required this.topicDescription,
    required this.readTime,
  });

  factory TopicDataPart.fromJson(Map<String, dynamic> json) {
    return TopicDataPart(
      topicTitle: json["topic_title"] ?? "", 
      topicDescription: json["topic_description"] ?? "",
      readTime: int.tryParse(json["topic_readtime"] ?? 0)
    );
  }
}


class BatchDetailModel{
  final String batchName;
  final String batchStartTime;
  final String batchEndTime;
  final String batchStartDate;
  final String batchEndDate;
  final String batchDays;
  final String batchTrainer;

  BatchDetailModel({
    required this.batchName,
    required this.batchStartTime,
    required this.batchEndTime,
    required this.batchStartDate,
    required this.batchEndDate,
    required this.batchDays,
    required this.batchTrainer,
  });


  factory BatchDetailModel.fromJson(Map<String, dynamic> json) {
    return BatchDetailModel(
      batchName: json["batch_name"] ?? "", 
      batchStartTime: json["batch_start_time"] ?? "", 
      batchEndTime: json["batch_end_time"] ?? "", 
      batchStartDate: json["batch_start_date"] ?? "", 
      batchEndDate: json["batch_end_date"] ?? "", 
      batchDays: json["batch_days"] ?? "", 
      batchTrainer: json["batch_trainer"] ?? ""
    );
  }
}

// batch_name
// batch_start_time
// batch_end_time
// batch_start_date
// batch_end_date
// batch_days
// batch_trainer

