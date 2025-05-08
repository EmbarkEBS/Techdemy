// ignore_for_file: non_constant_identifier_names

class CourseDetail {
  final int course_id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  final String tag_data;
  final String courseMaterial;
  //final List<ChapterData> chapter_data;

  CourseDetail({
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
  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
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
  /*factory CourseDetail.fromJson(Map<String,dynamic> json){
    //List<dynamic>? chapterDataJson=json['chapter_data'];
   // List<ChapterData> chapterdata=chapterDataJson?.map((chapterJson) => ChapterData.fromJson(chapterJson)).toList()??[];
   // List<ChapterData> chapterdata=(json['chapter_data']).map((chapterJson) => ChapterData.fromJson(chapterJson)).toList();
    return CourseDetail(
        course_id: json['results']['course_id'],
        name: json['results']['name'],
        description:json['results']['description'],
        price: json['results']['price'],
        duration: json['results']['duration'],
        image: json['results']['image'],
        tag_data: json['results']['tag_data'],
        //chapter_data: chapterdata,
    );
  }*/
}

class ChapterData {
  final int chapter_id;
  final String chapter_name;
  final String topic_data;

  ChapterData({
    required this.chapter_id,
    required this.chapter_name,
    required this.topic_data,
  });
  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      chapter_id: json['chapter_id'],
      chapter_name: json['chapter_name'],
      topic_data: json['topic_data'],
    );
  }
}


/*class CourseDetail{
  final int course_id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String image;
  //final String tag_name;
  final String tag_data;
  //final int chapter_id;
  List<ChapterData> chapter_data;
  // final String chapter_name;
  // final String topic_data;

  CourseDetail({
    required this.course_id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.image,
    required this.tag_data,
    required this.chapter_data,
    // required this.chapter_id,
    // required this.chapter_name,
    // required this.topic_data,
  });

  /*CoursesList(  this.course_id,
     this.name,
     this.description,
     this.price,
     this.duration,
     this.image,
     this.tag_data,
  );
  CoursesList.fromJson(Map<String,dynamic> json)
  :course_id=int.parse(json['course_id'] as String),
    name=json['name'],
    description=json['description'],
  price=json['price'],
  duration=json['duration'],
  image=json['image'],
  tag_data=json['tag_data'];

  Map<String,dynamic> toJson()=>{
      'course_id':course_id,
      'name':name,
      'description':description,
      'price':price,
      'duration':duration,
      'image':image,
      'tag_data':tag_data,
  };*/
  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      course_id: int.parse(json["course_id"].toString()),
      name: json["name"],
      description: json["description"],
      image: json["image"],
      price: json["price"],
      duration: json["duration"],
      tag_data: json["tag_data"],
      chapter_data: List<ChapterData>.from(json["chapter_data"].map((x)=>ChapterData.fromJson(x))),
      //chapter_data:List<ChapterData>.from(json['chapter_data'].map((chapterdata)=>ChapterData.fromJson(chapterdata))),

    );
  }
}
class ChapterData{
  final int chapter_id;
  final String chapter_name;
  final String topic_data;

   ChapterData({
      required this.chapter_id,
     required this.chapter_name,
     required this.topic_data,
    });
  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      chapter_id: int.parse(json["chapter_id"].toString()),
      chapter_name: json["chapter_name"] ,
      topic_data: json["topic_data"] ,
    );
  }
}*/