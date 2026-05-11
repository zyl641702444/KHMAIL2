import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/category_page.dart';
import 'pages/logistics_page.dart';
import 'pages/wallet_page.dart';
import 'pages/profile_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GoodMallApp());
}

class GoodMallApp extends StatefulWidget {
  const GoodMallApp({super.key});

  @override
  State<GoodMallApp> createState() => _GoodMallAppState();
}

class _GoodMallAppState extends State<GoodMallApp> {
  final ThemeController themeController = ThemeController();
  int tab = 0;

  @override
  void dispose() {
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        final theme = themeController.current;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoodMall',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: theme.primary),
            scaffoldBackgroundColor: theme.background,
            appBarTheme: AppBarTheme(
              centerTitle: false,
              backgroundColor: theme.background,
              foregroundColor: theme.text,
              elevation: 0,
            ),
          ),
          home: Scaffold(
            body: IndexedStack(
              index: tab,
              children: [
                HomePage(themeController: themeController),
                CategoryPage(themeController: themeController),
                LogisticsPage(themeController: themeController),
                WalletPage(themeController: themeController),
                ProfilePage(themeController: themeController),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: tab,
              onDestinationSelected: (v) => setState(() => tab = v),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_rounded), label: '首页'),
                NavigationDestination(icon: Icon(Icons.category_rounded), label: '分类'),
                NavigationDestination(icon: Icon(Icons.local_shipping_rounded), label: '物流'),
                NavigationDestination(icon: Icon(Icons.account_balance_wallet_rounded), label: '钱包'),
                NavigationDestination(icon: Icon(Icons.person_rounded), label: '我的'),
              ],
            ),
          ),
        );
      },
    );
  }
}
