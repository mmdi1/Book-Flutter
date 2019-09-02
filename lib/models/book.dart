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
      this.importUrl,
      this.isCache,
      this.cacheToUrl});
  int id;
  int isCache; //是否缓存了  0无缓存 1续存   2全本缓存
  String cacheToUrl; //缓存至url地址  方便续存
  String name;
  String author;
  String imgUrl;
  String info;
  String status;
  String wordCount;
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
    isCache = data['isCache'];
    cacheToUrl = data['cacheToUrl'];
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
    map["isCache"] = this.isCache;
    map["cacheToUrl"] = this.cacheToUrl;
    return map;
  }
}
