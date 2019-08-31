class Book {
  Book({this.name, this.author, this.info, this.wordCount, this.imgUrl,
      this.status, this.importUrl});
  int id;
  String name;
  String author;
  String imgUrl;
  String wordCount;
  String info;
  String status;
  String importUrl;

  Book.fromJson(Map data) {
    id = data['id'];
    name = data['name'];
    author = data['author'];
    imgUrl = data['imgUrl'];
    wordCount = data['wordCount'];
    info = data['info'];
    status = data['status'];
    importUrl = data['importUrl'];
  }

  /// jsonDecode(jsonStr) 方法中会调用实体类的这个方法。如果实体类中没有这个方法，会报错。
  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["name"] = this.name;
    map["author"] = this.author;
    map["wordCount"] = this.wordCount;
    map["info"] = this.info;
    map["imgUrl"] = this.imgUrl;
    map["status"] = this.status;
    map["importUrl"] = this.importUrl;
    return map;
  }
}
