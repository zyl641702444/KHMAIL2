import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class FeatureCenterPage extends StatefulWidget {
  const FeatureCenterPage({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  State<FeatureCenterPage> createState() => _FeatureCenterPageState();
}

class _FeatureCenterPageState extends State<FeatureCenterPage> {
  final api = GoodMallApiService();
  String output = 'V25-V39 功能中心';

  Future<void> call(String title, Future<ApiResult> future) async {
    setState(() => output = 'loading $title...');
    final r = await future;
    setState(() => output = r.raw);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    final buttons = <MapEntry<String, Future<ApiResult> Function()>>[
      MapEntry('系统检查', () => api.check()),
      MapEntry('钱包流水', () => api.walletLogs()),
      MapEntry('信用购物金', () => api.creditInfo()),
      MapEntry('商家入驻', () => api.merchantApply()),
      MapEntry('采集额度', () => api.merchantQuota()),
      MapEntry('推广点击', () => api.affiliateClick('1')),
      MapEntry('AI客服', () => api.aiChat('国际运费什么时候支付？')),
      MapEntry('后台统计', () => api.adminSummary()),
      MapEntry('本地配送', () => api.deliveryCreate()),
    ];
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('功能中心')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            theme: theme,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final b in buttons)
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: theme.primary),
                    onPressed: () => call(b.key, b.value()),
                    child: Text(b.key),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ApiOutputCard(theme: theme, output: output),
        ],
      ),
    );
  }
}
