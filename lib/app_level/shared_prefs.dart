import 'package:bml_supervisor/models/get_clients_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  final String selected_client = "selected_client";
  final String selected_duration = "selected_duration";

  void saveSelectedClient(GetClientsResponse selectedClient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedClient == null) {
      await prefs.remove(selected_client);
    } else {
      await prefs.setString(
          selected_client, selectedClient.toJson().toString());
    }
  }

  Future<GetClientsResponse> getSelectedClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedResponseString = prefs.getString(selected_client);
    if (savedResponseString == null) {
      return GetClientsResponse(id: 1, title: "Golden Harvest");
    } else {
      return GetClientsResponse.fromJson(savedResponseString);
    }
  }

  void saveSelectedDuration(String selectedDuration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (selectedDuration == null) {
      await prefs.remove(selected_duration);
    } else {
      await prefs.setString(selected_duration, selectedDuration);
    }
  }

  Future<String> getSelectedDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selected_client) ?? "THIS MONTH";
  }
}
