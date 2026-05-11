import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class OrderResultPage extends StatefulWidget {
  const OrderResultPage({
    super.key,
    required this.orderRaw,
    required this.packageRaw,
    required this.packageId,
    required this.themeController,
  });

  final String orderRaw;
  final String packageRaw;
  final String packageId;
  final ThemeController themeController;

  @override
  State<OrderResultPage> createState() => _OrderResultPageState();
}

class _OrderResultPageState extends State<OrderResultPage> {
  final api = GoodMallApiService();
  String output = '';

  Future<void> setAndPayShipping() async {
    final setFee = await api.setInternationalFee(widget.packageId);
    final payFee = await api.payInternationalFee(widget.packageId);
    final pickup = await api.createPickupCode(widget.packageId);
    if (!mounted) return;
    setState(() => output = '${setFee.raw}\n\n${payFee.raw}\n\n${pickup.raw}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('订单/包裹')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), gradient: LinearGradient(colors: [theme.primary, theme.secondary])),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 46),
              SizedBox(height: 10),
              Text('商品款已支付', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text('等待包裹到金边仓称重后，再支付国际运费。', style: TextStyle(color: Colors.white, height: 1.45)),
            ]),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: setAndPayShipping,
            icon: const Icon(Icons.qr_code_2_rounded),
            label: const Text('模拟到仓：支付国际运费 / 生成自提码'),
          ),
          const SizedBox(height: 14),
          ApiOutputCard(theme: theme, output: '订单返回：\n${widget.orderRaw}\n\n包裹返回：\n${widget.packageRaw}\n\n$output'),
        ],
      ),
    );
  }
}
