import 'package:thief_book_flutter/common/server/articels_curd.dart';
import 'package:thief_book_flutter/common/utils/request.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/chapter.dart';

class ArticleProvider {
  static Future<Article> fetchArticle(int articleId) async {
    var article = await Request.get(action: 'catalog');
    // var article = await LocalCrud.getArticel(articleId);
    // var response = await Request.get(action: 'article_$articleId');
    // var article = Article.fromJson(response);
    return article;
  }

  static Future<Article> getArticelByNovelId(int novelId) async {
    var article = await LocalCrud.getArticelByNovelId(novelId);
    return article;
  }

  static Future<List<dynamic>> getArticelAll(int novelId) async {
    var result = await LocalCrud.getArticelAllByNovelId(novelId);
    return result;
  }
}
