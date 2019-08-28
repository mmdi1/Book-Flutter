import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thief_book_flutter/common/config/config.dart';
import 'package:thief_book_flutter/common/utils/request.dart';
import 'package:thief_book_flutter/common/utils/screen.dart';
import 'package:thief_book_flutter/common/utils/sp_uitls.dart';
import 'package:thief_book_flutter/main.dart';
import 'dart:async';
import 'package:thief_book_flutter/models/article.dart';
import 'package:thief_book_flutter/models/chapter.dart';
import 'package:thief_book_flutter/views/reader/reader_config.dart';
import 'package:thief_book_flutter/views/reader/reader_page_agent.dart';
import 'package:thief_book_flutter/views/reader/reader_utils.dart';
import 'package:thief_book_flutter/views/reader/reader_view.dart';
import 'article_provider.dart';
import 'reader_menu.dart';

enum PageJumpType { stay, firstPage, lastPage }

class ReaderScene extends StatefulWidget {
  final int novelId;

  ReaderScene({this.novelId});

  @override
  ReaderSceneState createState() => ReaderSceneState();
}

class ReaderSceneState extends State<ReaderScene> with RouteAware {
  int pageIndex = 0;
  bool isMenuVisiable = false;
  PageController pageController = PageController(keepPage: false);
  bool isLoading = false;
  bool isCacheFlag = false;
  double topSafeHeight = 0;

  Article preArticle;
  Article currentArticle;
  Article nextArticle;

  List<Chapter> chapters = [];

  @override
  void initState() {
    super.initState();
    pageController.addListener(onScroll);

    setup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPop() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    pageController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void setup() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    topSafeHeight = Screen.topSafeHeight;

    List<dynamic> chaptersResponse = await Request.get(action: 'catalog');
    chaptersResponse.forEach((data) {
      chapters.add(Chapter.fromJson(data));
    });
    var idStr = this.widget.novelId.toString();
    var nextArticleId = 1;
    //获取已读到的章节
    var exArticleId = await SpUtils.getInt(Config.spCacheArticleId + idStr);
    if (exArticleId != null) {
      nextArticleId = exArticleId;
      print("取出的缓存章节id:$nextArticleId");
    } else {
      var currentArticle =
          await ArticleProvider.getArticelByNovelId(this.widget.novelId);
      nextArticleId = currentArticle.id;
      print("无缓存章节直接获取第一章id:$nextArticleId");
    }
    await resetContent(this.widget.novelId, nextArticleId, PageJumpType.stay);
  }

  resetContent(int novelId, int articleId, PageJumpType jumpType) async {
    currentArticle = await fetchArticle(articleId);
    if (currentArticle.preArticleId > 0) {
      preArticle = await fetchArticle(currentArticle.preArticleId);
    } else {
      preArticle = null;
    }
    if (currentArticle.nextArticleId > 0) {
      nextArticle = await fetchArticle(currentArticle.nextArticleId);
    } else {
      nextArticle = null;
    }
    if (jumpType == PageJumpType.firstPage) {
      pageIndex = 0;
    } else if (jumpType == PageJumpType.lastPage) {
      pageIndex = currentArticle.pageCount - 1;
    }
    if (jumpType != PageJumpType.stay) {
      pageController.jumpToPage(
          (preArticle != null ? preArticle.pageCount : 0) + pageIndex);
    }
    //取出缓存页数
    var cachePageIndex =
        await SpUtils.getInt(Config.spCacheArticleId + novelId.toString());
    print("缓存章节id: $articleId  取出的缓存页: $cachePageIndex");
    if (cachePageIndex != null) {
      pageIndex = cachePageIndex;
      isCacheFlag = true;
    }
    setState(() {});
  }

  onScroll() {
    var page = pageController.offset / Screen.width;

    var nextArtilePage = currentArticle.pageCount +
        (preArticle != null ? preArticle.pageCount : 0);
    if (page >= nextArtilePage) {
      print('到达下个章节了');
      preArticle = currentArticle;
      currentArticle = nextArticle;
      nextArticle = null;
      pageIndex = 0;
      pageController.jumpToPage(preArticle.pageCount);
      fetchNextArticle(currentArticle.nextArticleId);
      setState(() {});
    }
    if (preArticle != null && page <= preArticle.pageCount - 1) {
      print('到达上个章节了');
      nextArticle = currentArticle;
      currentArticle = preArticle;
      preArticle = null;
      pageIndex = currentArticle.pageCount - 1;
      pageController.jumpToPage(currentArticle.pageCount - 1);
      fetchPreviousArticle(currentArticle.preArticleId);
      setState(() {});
    }
    var bookid = this.widget.novelId.toString();
    SpUtils.setInt(Config.spCacheArticleId + bookid, currentArticle.id);
    print("章节缓存:  ${currentArticle.id}");
    SpUtils.setInt(Config.spCachePageIndex + bookid, pageIndex);
    print("页数缓存 pageIndex:$pageIndex");
  }

  fetchPreviousArticle(int articleId) async {
    if (preArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    preArticle = await fetchArticle(articleId);
    pageController.jumpToPage(preArticle.pageCount + pageIndex);
    isLoading = false;
    setState(() {});
  }

  fetchNextArticle(int articleId) async {
    if (nextArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    nextArticle = await fetchArticle(articleId);
    isLoading = false;
    setState(() {});
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
        isMenuVisiable = true;
      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  onPageChanged(int index) {
    var page = 0;
    if (!isCacheFlag) {
      page = index - (preArticle != null ? preArticle.pageCount : 0);
    }
    if (page < currentArticle.pageCount && page >= 0) {
      setState(() {
        pageIndex = page;
      });
    }
  }

  previousPage() {
    if (pageIndex == 0 && currentArticle.preArticleId == 0) {
      print("已经是第一页了");
      // Toast.show('已经是第一页了');
      return;
    }
    pageController.previousPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  nextPage() {
    if (pageIndex >= currentArticle.pageCount - 1 &&
        currentArticle.nextArticleId == 0) {
      print("已经最后一页了");
      // Toast.show('已经是最后一页了');
      return;
    }

    pageController.nextPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Widget buildPage(BuildContext context, int index) {
    var page = 0;
    if (!isCacheFlag) {
      page = index - (preArticle != null ? preArticle.pageCount : 0);
    }
    var article;
    if (page >= this.currentArticle.pageCount) {
      print("--下一章-------------$page");
      isCacheFlag = false;
      // 到达下一章了
      article = nextArticle;
      page = 0;
    } else if (page < 0) {
      // 到达上一章了
      print("--上一章---------page:$page----${preArticle.pageCount}");
      article = preArticle;
      page = preArticle.pageCount - 1;
    } else {
      page = pageIndex;
      print("--当前章-------------$page");
      article = this.currentArticle;
    }

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTap(details.globalPosition);
      },
      child: ReaderView(
          article: article, page: page, topSafeHeight: topSafeHeight),
    );
  }

  buildPageView() {
    if (currentArticle == null) {
      return Container();
    }
    int itemCount = (preArticle != null ? preArticle.pageCount : 0) +
        currentArticle.pageCount +
        (nextArticle != null ? nextArticle.pageCount : 0);
    print("前一章加当前章后一章总页数:$itemCount");
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,
    );
  }

  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }
    return ReaderMenu(
      chapters: chapters,
      articleIndex: currentArticle.currentIndex,
      onTap: hideMenu,
      onPreviousArticle: () {
        resetContent(this.widget.novelId, currentArticle.preArticleId,
            PageJumpType.firstPage);
      },
      onNextArticle: () {
        resetContent(this.widget.novelId, currentArticle.nextArticleId,
            PageJumpType.firstPage);
      },
      onToggleChapter: (Chapter chapter) {
        resetContent(this.widget.novelId, chapter.id, PageJumpType.firstPage);
      },
    );
  }

  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      this.isMenuVisiable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentArticle == null || chapters == null) {
      return Scaffold();
    }

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
            buildMenu(),
          ],
        ),
      ),
    );
  }
}