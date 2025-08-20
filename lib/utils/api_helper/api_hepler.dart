class ApiHelper {
  static String baseUrl = "https://argiltiles.com/api";
  static String assetsUrl = "https://argiltiles.com/";

  /// sliders
  static String getSliders = "$baseUrl/slider";

  /// sliders
  static String contactUs = "$baseUrl/contactus";

  /// new Arrival
  static String newArrival = "$baseUrl/newarrivals";

  /// inquiry
  static String inquiry = "$baseUrl/inquiry";

  /// quartzProduct
  static String quartzProduct = "$baseUrl/quartzproduct";

  /// spc product
  static String spcProduct = "$baseUrl/spcproduct";

  /// spc product
  static String login = "$baseUrl/login";

  /// spc product
  static String dashboard = "$baseUrl/dashboard";

  /// pagination links
  static String spcProductPagination({required String page, String? query}) =>
      "$baseUrl/spcproductpagination?page=$page&q=${query ?? ""}";
  static String quartzProductPagination({
    required String page,
    String? query,
  }) => "$baseUrl/quartzproductpagination?page=$page&q=${query ?? ""}";
}
