import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:peaceinapod/pages/start_page/start_page.dart';
import 'package:peaceinapod/providers/audioplayer.provider.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/providers/settings.provider.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SettingsProvider()),
    ChangeNotifierProvider(create: (context) => PIndexProvider()),
    ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return YaruTheme(
        data: const YaruThemeData(
            variant: YaruVariant.olive, themeMode: ThemeMode.dark),
        builder: (context, yaru, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: yaru.theme,
            darkTheme: yaru.darkTheme,
            home: const Scaffold(
              body: StartPage(),
            ),
          );
        });
  }
}
