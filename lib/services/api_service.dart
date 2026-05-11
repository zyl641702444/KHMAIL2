import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiResult {
  const ApiResult({
    required this.code,
    required this.message,
    required this.data,
    required this.raw,
  });

  final int code;
  final String message;
  final Map<String, dynamic> data;
  final String raw;

  bool get ok => code == 0;

  factory ApiResult.fromText(String text) {
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) {
        final dynamic dataValue = decoded['data'];
        return ApiResult(
          code: decoded['code'] is int
              ? decoded['code'] as int
              : int.tryParse('${decoded['code']}') ?? 998,
          message: '${decoded['message'] ?? ''}',
          data: dataValue is Map<String, dynamic> ? dataValue : <String, dynamic>{},
          raw: text,
        );
      }
    } catch (_) {}
    return ApiResult(code: 998, message: 'NOT_JSON', data: <String, dynamic>{}, raw: text);
  }
}

class GoodMallApiService {
  GoodMallApiService({
    this.baseUrl = 'https://api-test.khmail.cn/native-api/index.php',
    this.token = 'khmail_admin',
  });

  final String baseUrl;
  final String token;

  Future<ApiResult> get(String path, {Map<String, String> params = const {}}) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'path': path,
      'token': token,
      ...params,
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 25));
      return ApiResult.fromText(utf8.decode(response.bodyBytes));
    } catch (e) {
      return ApiResult(code: 999, message: 'NETWORK_ERROR: $e', data: {}, raw: '');
    }
  }

  Future<ApiResult> check() => get('v25-v39/check');

  Future<ApiResult> searchGoods({String keyword = '', String pageSize = '20'}) =>
      get('v25/search-auto', params: {'keyword': keyword, 'pageSize': pageSize});

  Future<ApiResult> goodsDetail(String id) =>
      get('v26/goods-detail-full', params: {'id': id});

  Future<ApiResult> createOrder({String goodsId = '1', String amount = '0', String userKey = 'app_user'}) =>
      get('v28/order/create', params: {'goods_id': goodsId, 'amount': amount, 'user_key': userKey});

  Future<ApiResult> payGoods(String orderId) =>
      get('v28/order/pay-goods', params: {'order_id': orderId});

  Future<ApiResult> createPackage(String orderId) =>
      get('v29/package/create', params: {'order_id': orderId});

  Future<ApiResult> packageDetail(String packageId) =>
      get('v29/package/detail', params: {'package_id': packageId});

  Future<ApiResult> setInternationalFee(String packageId) =>
      get('v30/shipping/set-fee', params: {
        'package_id': packageId,
        'international_fee': '4.5',
        'weight': '1',
      });

  Future<ApiResult> payInternationalFee(String packageId) =>
      get('v30/shipping/pay', params: {'package_id': packageId});

  Future<ApiResult> createPickupCode(String packageId) =>
      get('v31/pickup/create-code', params: {'package_id': packageId});

  Future<ApiResult> deliveryCreate() => get('v32/delivery/create');
  Future<ApiResult> walletLogs() => get('v33/wallet/logs');
  Future<ApiResult> creditInfo() => get('v34/credit/info');
  Future<ApiResult> merchantApply() => get('v35/merchant/apply');
  Future<ApiResult> merchantQuota() => get('v36/merchant/collect-quota');

  Future<ApiResult> affiliateClick(String goodsId) =>
      get('v37/affiliate/click', params: {'goods_id': goodsId});

  Future<ApiResult> aiChat(String prompt) =>
      get('v38/ai/chat', params: {'prompt': prompt});

  Future<ApiResult> adminSummary() => get('v39/admin/summary');
  Future<ApiResult> categories() => get('v42/categories');
  Future<ApiResult> goodsRichDetail(String goodsId) => get('v43/goods-rich-detail', params: {'goods_id': goodsId});
  Future<ApiResult> cartList() => get('v44/cart/list');
  Future<ApiResult> cartAdd(String goodsId) => get('v44/cart/add', params: {'goods_id': goodsId});
  Future<ApiResult> checkoutPreview() => get('v45/checkout/preview');
  Future<ApiResult> orderList() => get('v46/orders/list');
  Future<ApiResult> logisticsTimeline(String packageId) => get('v47/logistics/timeline', params: {'package_id': packageId});
  Future<ApiResult> shippingPreview(String packageId) => get('v48/shipping/preview', params: {'package_id': packageId});
  Future<ApiResult> pickupInfo(String packageId) => get('v49/pickup/info', params: {'package_id': packageId});
  Future<ApiResult> deliveryDetail() => get('v50/delivery/detail');
  Future<ApiResult> merchantCenter() => get('v51/merchant/center');
  Future<ApiResult> merchantPaidCollect() => get('v52/merchant/paid-collect');
  Future<ApiResult> merchantGoodsList() => get('v53/merchant/goods');
  Future<ApiResult> merchantOrderList() => get('v54/merchant/orders');
  Future<ApiResult> walletFull() => get('v55/wallet/full');
  Future<ApiResult> creditFull() => get('v56/credit/full');
  Future<ApiResult> affiliateCenter() => get('v57/affiliate/center');
  Future<ApiResult> aiCustomerService() => get('v58/ai/customer-service');
  Future<ApiResult> aiMarketing(String title) => get('v59/ai/marketing', params: {'title': title});
  Future<ApiResult> kgSummary() => get('v60/kg/summary');
  Future<ApiResult> adminDashboard() => get('v61/admin/dashboard');
  Future<ApiResult> adminOrders() => get('v62/admin/orders');
  Future<ApiResult> adminLogistics() => get('v63/admin/logistics');
  Future<ApiResult> checkV42V63() => get('v42-v63/check');

}
