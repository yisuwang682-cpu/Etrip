import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:image_picker/image_picker.dart';

class EgyptopiaApiService {
  static const String _baseUrl = 'http://192.168.1.12:8000/api/users';

  Future<bool> userExists(String id) async {
    final uri = Uri.parse('$_baseUrl/$id/');
    final response = await http.get(uri);
    return response.statusCode == 200;
  }

  Future<void> createUser(EgyptopiaUser user) async {
    final uri = Uri.parse('$_baseUrl/create/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to create user: ${response.body}");
    }
  }

  Future<EgyptopiaUser?> getUserById(String id) async {
    final uri = Uri.parse('$_baseUrl/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return EgyptopiaUser.fromMap(json.decode(response.body));
    }
    return null;
  }

  Future<void> updateUser(EgyptopiaUser user) async {
    final uri = Uri.parse('$_baseUrl/${user.id}/update/');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update user: ${response.body}");
    }
  }

  Future<void> updateUserProfileImage({
    required String userId,
    required XFile image,
  }) async {
    final uri = Uri.parse('$_baseUrl/$userId/update/');
    var request = http.MultipartRequest('PATCH', uri);
    request.files
        .add(await http.MultipartFile.fromPath('profile_img', image.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode != 200) {
      throw Exception("Failed to update image: ${response.body}");
    }
  }
}
