class KeyCenter {
  static final KeyCenter instance = KeyCenter._internal();
  KeyCenter._internal();

  // Developers can get appID from admin console.
  // https://console.zego.im/dashboard
  // for example: 123456789
  int appID = 1406963966;

  // This value only needs to be filled in when running on native (non-web).
  // AppSign only meets simple authentication requirements.
  // If you need to upgrade to a more secure authentication method,
  // please refer to [Guide for upgrading the authentication mode from using the AppSign to Token](https://docs.zegocloud.com/faq/token_upgrade)
  // Developers can get AppSign from admin [console](https://console.zego.im/dashboard)
  // for example: "abcdefghijklmnopqrstuvwxyz0123456789abcdegfhijklmnopqrstuvwxyz01"
  String appSign = 'f65aa391b0cff5bcce7a6b6b3aa1ae6d6a6ef4cd50b051435173c920c3cdcb3f';

  // This value only needs to be filled in when running on web browser.
  // Developers can get token from admin console: https://console.zego.im/dashboard
  // Note: The user ID used to generate the token needs to be the same as the userID filled in above!
  // for example: "04AAAAAxxxxxxxxxxxxxx"
  String token = '';

  // For internal testing on web (No need to fill in this value, just ignore it).
  String tokenServer = '';
}
