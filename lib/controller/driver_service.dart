// driver_api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DriverApiService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/auth/admin';

  // Method to get all drivers
  static Future<List<dynamic>> getAllDrivers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/getAllDrivers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final  data = json.decode(response.body);
           print("Driver details fetched: $data");

      // Extract and return the driverDetails list
      return data['driverDetails'];
    } else {
      throw Exception('Failed to load drivers');
    }
  }

static Future<Map<String, dynamic>> getDriverDetails(String driverId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  // print("Token retrieved: $token");

  final response = await http.get(
    Uri.parse('$baseUrl/viewDriver-Detail/$driverId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // print("Driver details fetched: $data");

    // Access `vehicleDetails` within `driverDetails`
    final driverDetails = data['driverDetails'];
    if (driverDetails != null) {
      final vehicleDetails = driverDetails['vehicleDetails'];

      if (vehicleDetails != null) {
        return data;
      } else {
        print("No vehicle details found.");
        return {}; // Return an empty map if `vehicleDetails` is null
      }
    } else {
      print("No driver details found.");
      return {}; // Return an empty map if `driverDetails` is null
    }
  } else {
    print("Failed to load driver details. Status Code: ${response.statusCode}");
    throw Exception('Failed to load driver details');
  }
}



Future<void>acceptDriver(String driverId ,)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
    // print('hre erwrwrww er werr     ewr${token}');


  final response=await http.patch(Uri.parse('$baseUrl/approveDriver/$driverId'),
  headers: {'Content-Type':'application/json',
  'Authorization': 'Bearer $token'
  },
  );

  if(response.statusCode ==200){
          print('success'); // Log the response body for debugging
    final data = json.decode(response.body);
    print("Driver details fetched: $data");
  }else{
    throw Exception('failed to accept driver');

  }
}

Future<void>blocunblocDriver(String driverId,bool isBlocked)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final response=await http.patch(Uri.parse('$baseUrl/blockUnblockDrivers/$driverId'),
  headers: {'Content-Type':'application/json',
 'Authorization': 'Bearer $token'
  
  },
  // body: jsonEncode({'isBlocked':isBlocked})
  );
  if(response.statusCode!=200){
          // print('Error: ${response.body}'); // Log the response body for debugging

      throw Exception('Failed to update block status');
  }
}


}
