import 'package:flutter/material.dart';
import '../models/goods.dart';
import '../theme/app_theme.dart';

class GoodsCard extends StatelessWidget {
  const GoodsCard({
    super.key,
    required this.goods,
    required this.theme,
    required this.onTap,
  });

  final Goods goods;
  final AppThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = goods.picUrl.startsWith('http');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.07),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Stack(children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    color: theme.background,
                    child: hasImage
                        ? Image.network(
                            goods.picUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.shopping_bag, color: theme.primary, size: 52),
                          )
                        : Icon(Icons.shopping_bag, color: theme.primary, size: 52),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [theme.secondary, theme.accent]),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('包邮', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.55),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('GoodMall Pick', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Text(
            goods.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.text, fontWeight: FontWeight.w900, height: 1.15),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                '\$${goods.priceUsd.toStringAsFixed(2)}',
                style: TextStyle(color: theme.primary, fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Icon(Icons.star_rounded, color: theme.secondary, size: 16),
              Text('4.8', style: TextStyle(color: theme.muted, fontSize: 11)),
            ],
          ),
        ]),
      ),
    );
  }
}
