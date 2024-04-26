class UrL {
  static Uri login = Uri.parse("https://backend.invest-ci.com/api/auth/login");
  static Uri logout =
      Uri.parse("https://backend.invest-ci.com/api/auth/logout");
  static Uri signIn =
      Uri.parse("https://backend.invest-ci.com/api/auth/signupMobile");
  static Uri listPack = Uri.parse("https://backend.invest-ci.com/api/publies");

  static Uri modifierProfil =
      Uri.parse("https://backend.invest-ci.com/api/profile/{id}");
  static Uri mesOperation =
      Uri.parse("https://backend.invest-ci.com/api/opes/{id}");
  static Uri achat = Uri.parse(
      "https://backend.invest-ci.com/api/achats"); //user_id, package_id
  static Uri user = Uri.parse("https://backend.invest-ci.com/api/auth/user");
}
