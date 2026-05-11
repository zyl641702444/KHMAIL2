import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_blocks.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.themeController});
  final ThemeController themeController;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}
class _CategoryPageState extends State<CategoryPage> {
  final api = GoodMallApiService();
  List<dynamic> items = [];
  String output = '';
  @override
  void initState() { super.initState(); load(); }
  Future<void> load() async {
    final r = await api.categories();
    setState(() { items = r.data['items'] is List ? r.data['items'] as List : []; output = r.raw; });
  }
  @override
  Widget build(BuildContext context) {
    final theme = widget.themeController.current;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(title: const Text('分类')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        GlassCard(theme: theme, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('热门分类', style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: .9),
            itemBuilder: (_, i) {
              final m = items[i] is Map ? items[i] as Map : {};
              return Column(children: [
                CircleAvatar(backgroundColor: theme.primary.withOpacity(.12), child: Icon(Icons.category_rounded, color: theme.primary)),
                const SizedBox(height: 6),
                Text('${m['name'] ?? '分类'}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: theme.text, fontSize: 12)),
              ]);
            },
          ),
        ])),
        const SizedBox(height: 14),
        ApiOutputCard(theme: theme, output: output),
      ]),
    );
  }
}
