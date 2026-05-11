import 'package:flutter/material.dart';
import '../models/goods.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/goods_card.dart';
import 'detail_page.dart';

class ImageSearchPage extends StatefulWidget {
  const ImageSearchPage({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  State<ImageSearchPage> createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final api = GoodMallApiService();
  final keywordController = TextEditingController(text: 'bag');
  bool loading = false;
  List<Goods> goods = [];

  Future<void> search() async {
    setState(() => loading = true);
    final r = await api.searchGoods(keyword: keywordController.text.trim(), pageSize: '20');
    if (!mounted) return;
    final rawItems = r.data['items'];
    setState(() {
      goods = rawItems is List
          ? rawItems.whereType<Map>().map((e) => Goods.fromJson(Map<String, dynamic>.from(e))).toList()
          : <Goods>[];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('AI 图片搜索')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), gradient: LinearGradient(colors: [theme.primary, theme.accent])),
            child: Column(children: [
              const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 52),
              const SizedBox(height: 8),
              const Text('Image Search', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              TextField(
                controller: keywordController,
                decoration: InputDecoration(
                  hintText: '临时用关键词模拟图片搜索',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(onPressed: search, child: const Text('搜索相似商品')),
            ]),
          ),
          const SizedBox(height: 14),
          if (loading) LinearProgressIndicator(color: theme.primary),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: goods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .66, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemBuilder: (_, i) {
              final item = goods[i];
              return GoodsCard(
                goods: item,
                theme: theme,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(goods: item, themeController: widget.themeController))),
              );
            },
          ),
        ],
      ),
    );
  }
}
