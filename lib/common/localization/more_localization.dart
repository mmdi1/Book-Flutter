/**
 *  Create by fazi
 *  Date: 2019-07-01
 */

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MoreLocalization implements CupertinoLocalizations {
  final Locale locale;

  MoreLocalization(this.locale);

  /// 基于Map，根据当前语言的 languageCode： en或zh来获取对应的文案
  static Map<String, BaseLanguage> _localValue = {
    'en': EnLanguage(),
    'zh': ChLanguage()
  };

  /// 返回当前的内容维护类
  BaseLanguage get currentLocalized {
    return _localValue[locale.languageCode];
  }

  ///通过 Localizations.of(context,type) 加载当前的 FZLocalizations
  static MoreLocalization of(BuildContext context) {
    return CupertinoLocalizations.of(context);

    /// 实现CupertinoLocalizations抽象类后，取不到对象，得换成CupertinoLocalizations.of(context);
//    return Localizations.of(context, MoreLocalization);
  }

  @override
  String get selectAllButtonLabel {
    return currentLocalized.selectAllButtonLabel;
  }

  @override
  String get pasteButtonLabel {
    return currentLocalized.pasteButtonLabel;
  }

  @override
  String get copyButtonLabel {
    return currentLocalized.copyButtonLabel;
  }

  @override
  String get cutButtonLabel {
    return currentLocalized.cutButtonLabel;
  }

  @override
  String get todayLabel {
    return "今天";
  }

  static const List<String> _shortWeekdays = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  static const List<String> _shortMonths = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _months = <String>[
    '01月',
    '02月',
    '03月',
    '04月',
    '05月',
    '06月',
    '07月',
    '08月',
    '09月',
    '10月',
    '11月',
    '12月',
  ];

  @override
  String datePickerYear(int yearIndex) => yearIndex.toString() + "年";

  @override
  String datePickerMonth(int monthIndex) => _months[monthIndex - 1];

  @override
  String datePickerDayOfMonth(int dayIndex) => dayIndex.toString() + "日";

  @override
  String datePickerHour(int hour) => hour.toString();

  @override
  String datePickerHourSemanticsLabel(int hour) => hour.toString() + " 小时";

  @override
  String datePickerMinute(int minute) => minute.toString().padLeft(2, '0');

  @override
  String datePickerMinuteSemanticsLabel(int minute) {
    return '1 分钟';
  }

  @override
  String datePickerMediumDate(DateTime date) {
    return '${_shortWeekdays[date.weekday - DateTime.monday]} '
        '${_shortMonths[date.month - DateTime.january]} '
        '${date.day.toString().padRight(2)}';
  }

  @override
  DatePickerDateOrder get datePickerDateOrder => DatePickerDateOrder.ymd;

  @override
  DatePickerDateTimeOrder get datePickerDateTimeOrder =>
      DatePickerDateTimeOrder.date_time_dayPeriod;

  @override
  String get anteMeridiemAbbreviation => 'AM';

  @override
  String get postMeridiemAbbreviation => 'PM';

  @override
  String get alertDialogLabel => '提示信息';

  @override
  String timerPickerHour(int hour) => hour.toString();

  @override
  String timerPickerMinute(int minute) => minute.toString();

  @override
  String timerPickerSecond(int second) => second.toString();

  @override
  String timerPickerHourLabel(int hour) => '时';

  @override
  String timerPickerMinuteLabel(int minute) => '分';

  @override
  String timerPickerSecondLabel(int second) => '秒';
}

/// 这个抽象类和它的实现类可以拉出去新建类
/// 中文和英语 语言内容维护
abstract class BaseLanguage {
  String name;
  String selectAllButtonLabel;
  String pasteButtonLabel;
  String copyButtonLabel;
  String cutButtonLabel;
}

class EnLanguage implements BaseLanguage {
  @override
  String name = "This is English";
  @override
  String selectAllButtonLabel = "select all";
  @override
  String pasteButtonLabel = "paste";
  @override
  String copyButtonLabel = "cpoy";
  @override
  String cutButtonLabel = "cutting";
}

class ChLanguage implements BaseLanguage {
  @override
  String name = "这是中文";
  @override
  String selectAllButtonLabel = "全选";
  @override
  String pasteButtonLabel = "粘贴";
  @override
  String copyButtonLabel = "复制";
  @override
  String cutButtonLabel = "剪切";
}
