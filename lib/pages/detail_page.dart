import 'package:flutter/material.dart';
import '../models/goods.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';
import 'order_result_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.goods, required this.themeController});
  final Goods goods;
  final ThemeController themeController;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final api = GoodMallApiService();
  bool loading = false;

  Future<void> buyNow() async {
    setState(() => loading = true);
    final order = await api.createOrder(goodsId: widget.goods.id, amount: widget.goods.priceUsd.toStringAsFixed(2));
    final orderId = '${order.data['order_id'] ?? '1'}';
    await api.payGoods(orderId);
    final pkg = await api.createPackage(orderId);
    if (!mounted) return;
    setState(() => loading = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderResultPage(
          orderRaw: order.raw,
          packageRaw: pkg.raw,
          packageId: '${pkg.data['package_id'] ?? '1'}',
          themeController: widget.themeController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    final hasImage = widget.goods.picUrl.startsWith('http');
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('商品详情')),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: theme.surface, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 22, offset: const Offset(0, -12)),
        ]),
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: theme.primary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: loading ? null : buyNow,
          icon: const Icon(Icons.shopping_bag_rounded),
          label: Text(loading ? '处理中...' : '立即购买 · 只支付商品款'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(28), boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 28, offset: const Offset(0, 14)),
            ]),
            child: Stack(children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: hasImage
                      ? Image.network(widget.goods.picUrl, fit: BoxFit.cover)
                      : Icon(Icons.shopping_bag, color: theme.primary, size: 90),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [theme.secondary, theme.accent]), borderRadius: BorderRadius.circular(999)),
                  child: const Text('FREE SHIPPING / 包邮', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Text(widget.goods.title, style: TextStyle(color: theme.text, fontSize: 23, fontWeight: FontWeight.w900, height: 1.15)),
          const SizedBox(height: 10),
          Text('\$${widget.goods.priceUsd.toStringAsFixed(2)}', style: TextStyle(color: theme.primary, fontSize: 34, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          GlassCard(
            theme: theme,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('跨境支付规则', style: TextStyle(color: theme.text, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text('商品款下单时支付；国际运费不是下单时付，而是货到金边/柬埔寨仓入库称重后再支付。支付国际运费后可选择自提或配送。',
                  style: TextStyle(color: theme.muted, height: 1.55)),
            ]),
          ),
          const SizedBox(height: 12),
          GlassCard(
            theme: theme,
            child: Row(children: [
              Icon(Icons.verified_rounded, color: theme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text('GoodMall 自营/商家商品 · 物流全程可追踪 · 到仓后再付国际运费', style: TextStyle(color: theme.text, fontWeight: FontWeight.w700))),
            ]),
          ),
        ],
      ),
    );
  }
}
