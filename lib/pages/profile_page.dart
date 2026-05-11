import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.themeController});
  final ThemeController themeController;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final api = GoodMallApiService();
  String output = '我的 GoodMall';
  Future<void> call(Future<ApiResult> f) async { final r = await f; setState(() => output = r.raw); }
  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    final menus = [
      ['我的订单', Icons.receipt_long_rounded, () => call(api.orderList())],
      ['商家中心', Icons.storefront_rounded, () => call(api.merchantCenter())],
      ['付费采集', Icons.cloud_download_rounded, () => call(api.merchantPaidCollect())],
      ['推广赚钱', Icons.share_rounded, () => call(api.affiliateCenter())],
      ['AI客服', Icons.smart_toy_rounded, () => call(api.aiCustomerService())],
      ['AI营销', Icons.campaign_rounded, () => call(api.aiMarketing('包邮精选商品'))],
      ['知识图谱', Icons.hub_rounded, () => call(api.kgSummary())],
      ['物流后台', Icons.warehouse_rounded, () => call(api.adminLogistics())],
    ];
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('我的')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlassCard(theme: theme, child: Row(children: [
          CircleAvatar(radius: 30, backgroundColor: theme.primary, child: const Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('GoodMall User', style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.w900)),
            Text('跨境购物会员 · 可使用钱包和信用购物金', style: TextStyle(color: theme.muted)),
          ])),
        ])),
        const SizedBox(height: 14),
        GlassCard(theme: theme, child: Column(children: [
          for (final m in menus)
            ListTile(
              leading: Icon(m[1] as IconData, color: theme.primary),
              title: Text(m[0] as String, style: TextStyle(color: theme.text, fontWeight: FontWeight.w800)),
              trailing: const Icon(Icons.chevron_right),
              onTap: m[2] as VoidCallback,
            ),
        ])),
        const SizedBox(height: 12),
        ApiOutputCard(theme: theme, output: output),
      ]),
    );
  }
}
