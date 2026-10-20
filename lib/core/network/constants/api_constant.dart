class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://test.deenstep.com/api/v1';

  //auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/sign-up/';
  static const String verifyOtp = '$baseUrl/auth/sign-up/verify/';
  static const String logout = 'auth/logout';
  static const String profile = 'profile';


  // home
  static String popular(String day) => '$baseUrl/items?day=$day';
  static String category = '$baseUrl/categories';
  static String items(String categoryId, {int page = 1, int limit = 20}) =>
      '${ApiConstants.baseUrl}/items?category=$categoryId&page=$page&limit=$limit';
  static String allPopular({int page = 1, int limit = 20}) =>
      '$baseUrl/items?page=$page&limit=$limit';
  static String addCart = '${ApiConstants.baseUrl}/cart/add';
  static String removeCart = '${ApiConstants.baseUrl}/cart/remove';
  static String removeOneCart = '${ApiConstants.baseUrl}/cart/reduce';
  static String getCart(String userId) => '${ApiConstants.baseUrl}/cart/$userId';
  static String fetchOrder = '${ApiConstants.baseUrl}/orders/my?filter=ongoing';




  static const String home = 'home';
  static const String orders = 'orders';
  static const String chat = 'chat';
}