import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thief_book_flutter/models/book.dart';

class BookRefreshProvider extends InheritedWidget {
  final Widget child;
  final BookBloc bloc;

  BookRefreshProvider({
    this.child,
    this.bloc,
  }) : super(child: child);

  static BookRefreshProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(BookRefreshProvider);

  @override
  bool updateShouldNotify(BookRefreshProvider oldWidget) {
    return true;
  }
}

class BookBloc {
  final _booksActionController = StreamController<int>();
  StreamSink<int> get refresh => _booksActionController.sink;
  final _counterController = StreamController<int>();
  Stream<int> get stream => _counterController.stream;
  BookBloc() {
    _booksActionController.stream.listen(onData);
  }
  void onData(int data) {
    print('$data');
    _counterController.add(data);
  }

  void disponse() {
    print("释放bookbloc");
    _booksActionController.close();
    _counterController.close();
  }

  void log() {
    print('BLoC');
  }
}
