import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key, required this.themeController});
  final ThemeController themeController;
  @override
  State<WalletPage> createState() => _WalletPageState();
}
class _WalletPageState extends State<WalletPage> {
  final api = GoodMallApiService();
  String output = '';
  Future<void> call(Future<ApiResult> f) async { final r = await f; setState(() => output = r.raw); }
  @override
  void initState() { super.initState(); call(api.walletFull()); }
  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('钱包')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: LinearGradient(colors: [theme.primary, theme.secondary])),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('GoodMall Wallet', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            SizedBox(height: 12),
            Text('\$100.00', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
            Text('商品款 / 国际运费 / 配送费分开记账', style: TextStyle(color: Colors.white)),
          ]),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: [
          FilledButton(onPressed: () => call(api.walletFull()), child: const Text('钱包流水')),
          FilledButton(onPressed: () => call(api.creditFull()), child: const Text('信用购物金')),
          FilledButton(onPressed: () => call(api.adminDashboard()), child: const Text('后台统计')),
        ]),
        const SizedBox(height: 12),
        ApiOutputCard(theme: theme, output: output),
      ]),
    );
  }
}
