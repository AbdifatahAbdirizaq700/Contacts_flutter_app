import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/contact.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.56.1/contacts_api/api/';

  // Get all contacts
  Future<List<Contact>> getContacts() async {
    final response = await http.get(Uri.parse('${baseUrl}read.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  // Add new contact
  Future<void> addContact(String name, String phone, String email) async {
    final response = await http.post(
      Uri.parse('${baseUrl}create.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add contact');
    }
  }

  // Update contact
  Future<void> updateContact(
      int id, String name, String phone, String email) async {
    final response = await http.post(
      Uri.parse('${baseUrl}update.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update contact');
    }
  }

  // Delete contact
  Future<void> deleteContact(int id) async {
    final response = await http.post(
      Uri.parse('${baseUrl}delete.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete contact');
    }
  }

  // Add to favorites
  Future<void> addToFavorites(int contactId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}add_favorite.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'contact_id': contactId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorites');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(int contactId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}remove_favorite.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'contact_id': contactId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }

  // Get favorite contacts
  Future<List<Contact>> getFavorites() async {
    final response = await http.get(Uri.parse('${baseUrl}get_favorites.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  // User registration
  Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register user');
    }

    final responseData = json.decode(response.body);
    if (responseData['message'] != 'User registered successfully') {
      throw Exception(responseData['message']);
    }
  }

  // User login
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login');
    }

    final responseData = json.decode(response.body);
    if (responseData['message'] != 'Login successful') {
      throw Exception(responseData['message']);
    }
  }
}
