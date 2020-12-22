class MyPreferences {
  final String _app_ip_address = "IP_ADDRESS";
  // void saveIpAddress(String ipAddress) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (ipAddress == null) {
  //     await prefs.remove(_app_ip_address);
  //   } else {
  //     await prefs.setString(_app_ip_address, ipAddress);
  //   }
  // }
  //
  // Future<String> getIpAddress() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_app_ip_address);
  // }
}
