import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sticker_fun/pages/home_page.dart';
import 'package:sticker_fun/themes/theme_repository.dart';
import 'package:sticker_fun/themes/theme_service.dart';
import 'package:sticker_fun/themes/theme_store.dart';

import 'controllers/theme_changer.dart';

void main() => runApp(
      EasyLocalization(
          saveLocale: false,
          useOnlyLangCode: true,
          supportedLocales: [
            Locale('en'),
            Locale('es'),
            Locale('fr'),
            Locale('nl'),
            Locale('pl'),
            Locale('pt'),
            Locale('ru'),
            Locale('de'),
            Locale('it'),
            Locale('fa'),
          ],
          path: 'assets/langs',
          child: MyApp()),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(
            create: (_) =>
                ThemeStore(ThemeService(ThemeRepository()))..getTheme())
      ],
      child: Consumer<ThemeStore>(
        builder: (_, ThemeStore value, __) => Observer(
          builder: (_) => MaterialApp(
            localizationsDelegates: [
              EasyLocalization.of(context).delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: EasyLocalization.of(context).supportedLocales,
            locale: EasyLocalization.of(context).locale,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: value.theme,
            home: HomePage(),
          ),
        ),
      ),
    );
  }
}
