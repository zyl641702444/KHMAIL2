class Goods {
  const Goods({
    required this.id,
    required this.title,
    required this.picUrl,
    required this.priceUsd,
    required this.source,
  });

  final String id;
  final String title;
  final String picUrl;
  final double priceUsd;
  final String source;

  factory Goods.fromJson(Map<String, dynamic> json) {
    double parsePrice(dynamic v) => double.tryParse('${v ?? 0}') ?? 0;
    return Goods(
      id: '${json['id'] ?? json['goods_id'] ?? '1'}',
      title: '${json['title'] ?? json['goods_title'] ?? json['goods_name'] ?? 'GoodMall 商品'}',
      picUrl: '${json['pic_url'] ?? json['image'] ?? json['thumb'] ?? ''}',
      priceUsd: parsePrice(json['price_usd'] ?? json['price'] ?? json['final_price'] ?? json['sell_price']),
      source: '${json['source'] ?? 'gm_goods'}',
    );
  }
}
