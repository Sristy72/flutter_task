class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://test.deenstep.com/api/v1';

  //auth
  static const String login = '$baseUrl/auth/login/';
  static const String guestLogin = '$baseUrl/auth/guest/login/';
  static const String register = '$baseUrl/auth/sign-up/';
  static const String verifyOtp = '$baseUrl/auth/sign-up/verify/';
  static const String logout = 'auth/logout';


  // home
  static const String dashboard = '$baseUrl/user/dashboard/';





  static const String home = 'home';
  static const String orders = 'orders';
  static const String chat = 'chat';
}