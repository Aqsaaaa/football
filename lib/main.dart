import 'package:flutter/material.dart';
import 'package:football_app/bottom_bar.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  void getCurrentTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.themePrefs.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

//   @override
//   Widget build(BuildContext context) {
//     return widget(
//       child: MaterialApp(
//         title: 'Football Data Flutter',
//         theme: ThemeData(
//           brightness: Brightness.dark,
//         ),
//         home: const HomeScreen(),
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeProvider.darkTheme, context),
          home: Builder(builder: (context) {
            return const HomeScreen();
          }),
        );
      }),
    );
  }
}
