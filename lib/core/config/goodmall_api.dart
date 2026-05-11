
class GoodMallApi {

  static const String baseUrl = 'https://api-test.khmail.cn';



  static const String health = '$baseUrl/api/native/health';

  static const String goodsCheck = '$baseUrl/api/goods/check';

  static const String goodsSearch = '$baseUrl/api/goods/search';

  static const String goodsHome = '$baseUrl/api/goods/home';

  static const String goodsList = '$baseUrl/api/goods/list';



  static Uri searchUri({

    required String keyword,

    int page = 1,

    int pageSize = 20,

  }) {

    return Uri.parse(goodsSearch).replace(queryParameters: {

      'keyword': keyword,

      'page': page.toString(),

      'pageSize': pageSize.toString(),

    });

  }



  static Uri homeUri({

    int page = 1,

    int pageSize = 20,

  }) {

    return Uri.parse(goodsHome).replace(queryParameters: {

      'page': page.toString(),

      'pageSize': pageSize.toString(),

    });

  }

}

