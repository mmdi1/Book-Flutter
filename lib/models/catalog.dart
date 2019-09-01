class Catalog {
  Catalog(this.id, this.title, this.linkUrl, this.index);
  int id;
  String title;
  String linkUrl;
  int index;
  Catalog.fromJson(Map data) {
    id = data['id'];
    title = data['title'];
    linkUrl = data['linkUrl'];
    index = data['index'];
  }
  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["title"] = this.title;
    map["index"] = this.index;
    map["linkUrl"] = this.linkUrl;
    return map;
  }
}
