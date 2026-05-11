import 'config/goodmall_api_config.dart';

void main() {
  print('BASE_URL=${GoodMallApiConfig.baseUrl}');
  print('SEARCH=${GoodMallApiConfig.uri(GoodMallApiConfig.goodsSearch, {'keyword': '手机', 'page': 1, 'pageSize': 10})}');
  print('TAOBAO_FALLBACK=${GoodMallApiConfig.uri(GoodMallApiConfig.taobaoNativeSdkSearch, {'keyword': '手机', 'page': 1, 'pageSize': 10})}');
  print('DETAIL_SKU=${GoodMallApiConfig.uri(GoodMallApiConfig.goodsDetailSku, {'id': 'TEST_ID'})}');
}
