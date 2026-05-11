import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class LogisticsPage extends StatefulWidget {
  const LogisticsPage({super.key, required this.themeController});
  final ThemeController themeController;
  @override
  State<LogisticsPage> createState() => _LogisticsPageState();
}
class _LogisticsPageState extends State<LogisticsPage> {
  final api = GoodMallApiService();
  String output = '';
  Future<void> call(Future<ApiResult> f) async { final r = await f; setState(() => output = r.raw); }
  @override
  void initState() { super.initState(); call(api.logisticsTimeline('1')); }
  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    final steps = ['中国仓入库', '中国仓出仓', '国际运输中', '到达金边', '待付国际运费', '待自提/配送'];
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('物流')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlassCard(theme: theme, child: Column(children: [
          for (int i = 0; i < steps.length; i++)
            ListTile(
              leading: CircleAvatar(backgroundColor: theme.primary, child: Text('${i + 1}', style: const TextStyle(color: Colors.white))),
              title: Text(steps[i], style: TextStyle(color: theme.text, fontWeight: FontWeight.w800)),
              subtitle: Text(i == 4 ? '到金边仓称重后再付' : '系统自动更新轨迹', style: TextStyle(color: theme.muted)),
            ),
        ])),
        const SizedBox(height: 12),
        Wrap(spacing: 10, children: [
          FilledButton(onPressed: () => call(api.shippingPreview('1')), child: const Text('运费预览')),
          FilledButton(onPressed: () => call(api.pickupInfo('1')), child: const Text('自提码')),
          FilledButton(onPressed: () => call(api.deliveryDetail()), child: const Text('配送')),
        ]),
        const SizedBox(height: 12),
        ApiOutputCard(theme: theme, output: output),
      ]),
    );
  }
}
