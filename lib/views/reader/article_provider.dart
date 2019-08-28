import 'package:thief_book_flutter/common/server/articels_curd.dart';
import 'package:thief_book_flutter/models/article.dart';

class ArticleProvider {
  static Future<Article> fetchArticle(int articleId) async {
    var article = await LocalCrud.getArticel(articleId);
    // var response = await Request.get(action: 'article_$articleId');
    // var article = Article.fromJson(response);
    return article;
  }

  static Future<Article> getArticelByNovelId(int novelId) async {
    var article = await LocalCrud.getArticelByNovelId(novelId);
    return article;
  }
}
