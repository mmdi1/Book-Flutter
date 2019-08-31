class Book {
  Book(
      {this.name,
      this.author,
      this.info,
      this.wordCount,
      this.imgUrl,
      this.status,
      this.sourceAddress,
      this.sourceType,
      this.catalogUrl,
      this.importUrl});
  int id;
  String name;
  String author;
  String imgUrl;
  String wordCount;
  String info;
  String status;
  String catalogUrl;
  String importUrl;
  String sourceAddress;
  String sourceType;

  Book.fromJson(Map data) {
    id = data['id'];
    name = data['name'];
    author = data['author'];
    imgUrl = data['imgUrl'];
    wordCount = data['wordCount'];
    info = data['info'];
    sourceAddress = data['sourceAddress'];
    status = data['status'];
    catalogUrl = data['catalogUrl'];
    importUrl = data['importUrl'];
    sourceType = data["sourceType"];
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
    map["catalogUrl"] = this.catalogUrl;
    map["sourceAddress"] = this.sourceAddress;
    map["sourceType"] = this.sourceType;
    return map;
  }
}
