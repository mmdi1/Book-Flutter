import 'dart:async';

import 'package:flutter/material.dart';

class HomeStreamCore {
  static StreamController<int> streamController;
  static StreamSink _sinkStream;
}
