class Chapter {
  Chapter({this.id, this.title, this.linkUrl, this.index});
  int id;
  String title;
  String linkUrl;
  int index;
  Chapter.fromJson(Map data) {
    id = data['id'];
    title = data['title'].toString().length > 20
        ? data['title'].toString().substring(0, 19) + ".."
        : data['title'];
    index = data['index'];
    linkUrl = data["linkUrl"];
  }
}
