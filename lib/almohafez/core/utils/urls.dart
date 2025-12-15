class Urls {
  static const String baseUrl = 'http://5.78.67.64';
  // static const String accessToken = '/auth/refresh';

  static const String accessToken = '/customer/api/v1/token/refresh/';
  static String updateBooking(String id) {
    return '/customer/api/v1/bookings/$id/update/';
  }

  static const String search = '/customer/api/v1/restaurants/';
  static const String rateing = '/customer/api/v1/rate/';
  static const String sendOtp = '/customer/api/v1/send-messge/';
  static const String verifyOtp = '/customer/api/v1/check-code/';
  static const String refreshToken = '/customer/api/v1/token/refresh/';
  static const String logout = '/customer/api/v1/logout/';
  static const String login = '/customer/api/v1/login/';
  static const String updateProfile = '/customer/api/v1/update-profile/';

  // static const String updateProfile = '${baseUrl}customer/api/v1/update-profile/';
  // static const String getDetaleBooking = '/customer/api/v1/bookings/4a96f89b-159a-4cf2-a788-c09f20408e24/update/';
  static const String getDetaleBooking = '/customer/api/v1/bookings/';
  // static const String sendOtp = '/api/v1/sendMessge/';
  // static const String verifyOtp = '/api/v1/checkcode/';
  // static const String refreshToken = '/api/v1/token/refresh/';
  // static const String logout = '/api/v1/logout/';

  static const String allRestaurants = '/customer/api/v1/restaurants/';
  static const String menuItems = '/customer/api/v1/menu-items/';
  static const String getOrder = '/customer/api/v1/orders/';
  static const String trackPayment = '/customer/api/v1/payments/track/';
  static const String createOrder = '/customer/api/v1/CreateOrders/';
  static const String getTables = '/customer/api/v1/tables/';
  static const String booking = '/customer/api/v1/bookings/';
}
