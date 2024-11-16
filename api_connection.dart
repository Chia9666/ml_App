class API {
  static const hostConnect = "http://192.168.68.107/server_api";
  static const userConnect = "http://192.168.68.107/server_api/users_api";
  static const predictConnect =
      "http://192.168.68.107/server_api/prediction_api";

// registration
  static const validateEmail = "$userConnect/email_validator.php";
  static const signUp = "$userConnect/signup.php";

// login
  static const login = "$userConnect/login.php";

// save prediction
  static const savePrediction = "$predictConnect/save_prediction.php";
}
