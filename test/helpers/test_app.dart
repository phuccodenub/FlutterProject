import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget wrapWithAppHome(
  Widget home, {
  List<Override> overrides = const [],
  Locale startLocale = const Locale('vi'),
}) {
  return ProviderScope(
    overrides: overrides,
    child: EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('vi'),
      startLocale: startLocale,
      child: Builder(
        builder: (ctx) => MaterialApp(
          locale: ctx.locale,
          supportedLocales: ctx.supportedLocales,
          localizationsDelegates: ctx.localizationDelegates,
          home: home,
        ),
      ),
    ),
  );
}

Widget wrapWithScaffoldBody(
  Widget body, {
  List<Override> overrides = const [],
  Locale startLocale = const Locale('vi'),
}) {
  return wrapWithAppHome(
    Scaffold(body: body),
    overrides: overrides,
    startLocale: startLocale,
  );
}
