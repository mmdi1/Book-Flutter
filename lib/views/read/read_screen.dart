import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';
import 'package:thief_book_flutter/common/utils/utility.dart';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/views/read/read_view.dart';
import 'package:thief_book_flutter/views/read/reader_config.dart';
import 'package:thief_book_flutter/views/read/reader_page_agent.dart';
import 'package:thief_book_flutter/views/reader/article_provider.dart';
import 'package:thief_book_flutter/views/reader/reader_utils.dart';

enum PageJumpType { stay, firstPage, lastPage }

class ReadScreen extends StatefulWidget {
  final int novelId;

  ReadScreen({this.novelId});
  ReadSceneState createState() => ReadSceneState();
}

class ReadSceneState extends State<ReadScreen> {
  int pageIndex = 0;
  double topSafeHeight = 0;
  Article preArticle;
  Article currentArticle;
  Article nextArticle;
  int currentPageCount = 0;
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 300), () {});
    // var idStr = this.widget.novelId.toString();
    var nextArticleId = 1;
    // //获取已读到的章节
    // var exArticleId = await SpUtils.getInt(Config.spCacheArticleId + idStr);
    // if (exArticleId != null) {
    //   nextArticleId = exArticleId;
    //   print("取出的缓存章节id:$nextArticleId");
    // } else {
    //   var currentArticle =
    //       await ArticleProvider.getArticelByNovelId(this.widget.novelId);
    //   nextArticleId = currentArticle.id;
    //   print("无缓存章节直接获取第一章id:$nextArticleId");
    // }
    var currentArticle =
        await ArticleProvider.getArticelByNovelId(this.widget.novelId);
    nextArticleId = currentArticle.id;
    await resetContent(nextArticleId, PageJumpType.stay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Image.asset('assets/images/read_bg.png',
                    fit: BoxFit.cover)),
            buildPageView(),
            // buildMenu(),
          ],
        ),
      ),
    );
  }

  resetContent(int articleId, PageJumpType jumpType) async {
    currentArticle = await fetchArticle(articleId);
    currentPageCount = currentArticle.pageCount - 1;
    setState(() {});
  }

  buildPageView() {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: PageController(
        initialPage: 0, //初始的页面index
        keepPage: false, //是否记录当前页 true返回后进来还是退出时的索引
        viewportFraction: 1, //占屏比
      ),
      itemCount: (currentArticle == null ? 1 : (currentArticle.pageCount)),
      onPageChanged: onPageChanged,
      itemBuilder: _pageItemBuilder,
    );
  }

//实际的每一页 翻页触发
  Widget _pageItemBuilder(BuildContext context, int index) {
    var page = index;
    var article;
    article = this.currentArticle;
    return GestureDetector(
        onTapUp: (TapUpDetails details) {
          onTap(details.globalPosition);
        },
        child: ReadView(
          article: article,
          page: page,
          topSafeHeight: topSafeHeight,
        ));
  }

  Future<Article> fetchArticle(int articleId) async {
    var article = await ArticleProvider.fetchArticle(articleId);
    var contentHeight = Screen.height -
        topSafeHeight -
        ReaderUtils.topOffset -
        Screen.bottomSafeHeight -
        ReaderUtils.bottomOffset -
        20;
    var contentWidth = Screen.width - 15 - 10;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(article.content,
        contentHeight, contentWidth, ReaderConfig.instance.fontSize);

    return article;
  }

  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      setState(() {
        print("唤出菜单");
        // isMenuVisiable = true;
      });
    } else if (xRate >= 0.66) {
      // nextPage();
      print("下一页");
    } else {
      print("上一页");
      // previousPage();
    }
  }

  onPageChanged(int index) async{
    if (index == currentArticle.pageCount - 1) {
      print("-----------------${currentArticle.preArticleId}");
      await resetContent(currentArticle.nextArticleId,PageJumpType.lastPage);
      setState(() {
      });
    }
  }
}
