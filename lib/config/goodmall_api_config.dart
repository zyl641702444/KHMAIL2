class GoodMallApiConfig {
  static const String baseUrl = 'https://api-test.khmail.cn';

  // 商品搜索：后端已实现本地 gm_goods 优先；本地没有自动淘宝 SDK 采集兜底；最终必须返回数据。
  static const String goodsSearch = '/api/goods/search';

  // 淘宝采集兜底：新后端直接复用老系统 Taobao SDK，不再走 ht.khmail.cn 老路由。
  static const String taobaoNativeSdkSearch = '/api/taobao/native-sdk-search';

  // 商品详情 + SKU：本地详情优先；没有真实 SKU 时默认 SKU 兜底。
  static const String goodsDetailSku = '/api/goods/detail-sku-v1';
  static const String goodsDetail = '/api/goods/detail';

  static Uri uri(String path, [Map<String, dynamic>? query]) {
    final qp = <String, String>{};
    if (query != null) {
      query.forEach((key, value) {
        if (value != null) qp[key] = value.toString();
      });
    }
    return Uri.parse(baseUrl + path).replace(queryParameters: qp.isEmpty ? null : qp);
  }
}
