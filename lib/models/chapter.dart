class Chapter {
  int id;
  String title;
  int index;

  Chapter.fromJson(Map data) {
    id = data['id'];
    title = data['title'].toString().length > 20
        ? data['title'].toString().substring(0, 19) + ".."
        : data['title'];
    index = data['currentIndex'];
  }
}
