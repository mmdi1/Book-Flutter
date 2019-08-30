class Catalog {
  Catalog(this.id, this.title, this.index);
  int id;
  String title;
  int index;
  Catalog.fromJson(Map data) {
    id = data['id'];
    title = data['title'];
    index = data['index'];
  }
  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["title"] = this.title;
    map["index"] = this.index;
    return map;
  }
}
