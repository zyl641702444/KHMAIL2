import 'package:flutter/material.dart';
import '../models/goods.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/goods_card.dart';
import '../widgets/ui_blocks.dart';
import 'detail_page.dart';
import 'feature_center_page.dart';
import 'image_search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = GoodMallApiService();
  final keywordController = TextEditingController(text: 'bag');
  bool loading = false;
  String message = '';
  List<Goods> goods = [];

  @override
  void initState() {
    super.initState();
    widget.themeController.addListener(_refreshTheme);
    load();
  }

  void _refreshTheme() => setState(() {});

  @override
  void dispose() {
    widget.themeController.removeListener(_refreshTheme);
    keywordController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      message = '';
    });
    final r = await api.searchGoods(keyword: keywordController.text.trim(), pageSize: '20');
    if (!mounted) return;
    if (r.ok) {
      final rawItems = r.data['items'];
      final list = rawItems is List
          ? rawItems.whereType<Map>().map((e) => Goods.fromJson(Map<String, dynamic>.from(e))).toList()
          : <Goods>[];
      setState(() {
        goods = list;
        message = r.data['auto_import'] == true ? '本地无结果，已自动淘宝采集入库' : '本地商品优先，秒开体验';
        loading = false;
      });
    } else {
      setState(() {
        message = r.message;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    return Scaffold(
      backgroundColor: theme.background,
      body: RefreshIndicator(
        onRefresh: load,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: theme.background,
              foregroundColor: theme.text,
              title: const Text('GoodMall', style: TextStyle(fontWeight: FontWeight.w900)),
              actions: [
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeatureCenterPage(themeController: widget.themeController))),
                  icon: const Icon(Icons.grid_view_rounded),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Column(
                  children: [
                    _Hero(theme: theme),
                    const SizedBox(height: 14),
                    _SearchBar(
                      theme: theme,
                      controller: keywordController,
                      onSearch: load,
                      onImageSearch: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImageSearchPage(themeController: widget.themeController))),
                    ),
                    const SizedBox(height: 14),
                    _ThemeSwitcher(themeController: widget.themeController),
                    const SizedBox(height: 14),
                    _FeatureGrid(theme: theme, themeController: widget.themeController),
                    const SizedBox(height: 12),
                    if (loading) LinearProgressIndicator(color: theme.primary),
                    if (message.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(message, style: TextStyle(color: theme.muted, fontWeight: FontWeight.w600)),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Today Picks', style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.w900)),
                        const Spacer(),
                        Text('FREE SHIPPING', style: TextStyle(color: theme.secondary, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final item = goods[i];
                    return GoodsCard(
                      goods: item,
                      theme: theme,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(goods: item, themeController: widget.themeController)),
                      ),
                    );
                  },
                  childCount: goods.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .66,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.theme});
  final AppThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: [theme.primary, theme.secondary, theme.accent]),
        boxShadow: [
          BoxShadow(color: theme.primary.withOpacity(.25), blurRadius: 28, offset: const Offset(0, 18)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.18), borderRadius: BorderRadius.circular(999)),
                child: const Text('Cross-border · Cambodia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(height: 12),
              const Text('Premium Futuristic E-Commerce', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.05)),
              const SizedBox(height: 8),
              const Text('商品款先付，国际运费到金边仓称重后再付', style: TextStyle(color: Colors.white, height: 1.4)),
            ]),
          ),
          const SizedBox(width: 10),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 42),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.theme,
    required this.controller,
    required this.onSearch,
    required this.onImageSearch,
  });

  final AppThemeData theme;
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onImageSearch;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(18), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 14, offset: const Offset(0, 8)),
          ]),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
      ),
      const SizedBox(width: 10),
      IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: theme.primary),
        onPressed: onImageSearch,
        icon: const Icon(Icons.camera_alt_rounded),
      ),
      const SizedBox(width: 8),
      IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: theme.secondary),
        onPressed: onSearch,
        icon: const Icon(Icons.auto_awesome_rounded),
      ),
    ]);
  }
}

class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher({required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final theme = themeController.current;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themeController.themes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final t = themeController.themes[i];
          return ChoiceChip(
            selected: themeController.index == i,
            label: Text(t.name),
            selectedColor: theme.primary.withOpacity(.18),
            onSelected: (_) => themeController.change(i),
          );
        },
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.theme, required this.themeController});
  final AppThemeData theme;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      theme: theme,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FeaturePill(theme: theme, icon: Icons.flash_on_rounded, title: '秒杀', onTap: () {}),
          FeaturePill(theme: theme, icon: Icons.group_rounded, title: '拼团', onTap: () {}),
          FeaturePill(theme: theme, icon: Icons.storefront_rounded, title: '店铺街', onTap: () {}),
          FeaturePill(theme: theme, icon: Icons.confirmation_number_rounded, title: '优惠券', onTap: () {}),
          FeaturePill(theme: theme, icon: Icons.qr_code_2_rounded, title: '自提码', onTap: () {}),
          FeaturePill(theme: theme, icon: Icons.account_balance_wallet_rounded, title: '钱包', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeatureCenterPage(themeController: themeController)))),
          FeaturePill(theme: theme, icon: Icons.smart_toy_rounded, title: 'AI客服', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeatureCenterPage(themeController: themeController)))),
          FeaturePill(theme: theme, icon: Icons.share_rounded, title: '推广', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeatureCenterPage(themeController: themeController)))),
        ],
      ),
    );
  }
}
