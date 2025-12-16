import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu.dart';

class MenuService {
  // Gunakan IP lokal
  static const String baseUrl = 'http://localhost:8000/api/menu';

  // Get all menu (READ)
  Future<List<Menu>> getMenus() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Debug: print struktur data
        print('Response keys: ${responseData.keys}');

        // Menyesuaikan dengan struktur respons Laravel
        if (responseData.containsKey('data')) {
          final data = responseData['data'];

          // Cek apakah data memiliki nested 'data' lagi
          if (data is Map && data.containsKey('data')) {
            final List<dynamic> menuList = data['data'];
            print('Found ${menuList.length} menu in nested data.data');
            return menuList.map((json) {
              return Menu(
                id: json['id'] ?? 0,
                nama: json['nama_menu'] ?? '',
                kategori: json['kategori'] ?? '',
                stok: json['stok'] ?? 0,
                harga: double.tryParse(json['harga'].toString()) ?? 0.0,
                gambar: json['gambar'] ?? '',
              );
            }).toList();
          }
          // Jika data langsung berisi array
          else if (data is List) {
            print('Found ${data.length} menu in data list');
            return data.map((json) {
              return Menu(
                id: json['id'] ?? 0,
                nama: json['nama_menu'] ?? '',
                kategori: json['kategori'] ?? '',
                stok: json['stok'] ?? 0,
                harga: double.tryParse(json['harga'].toString()) ?? 0.0,
                gambar: json['gambar'] ?? '',
              );
            }).toList();
          }
        }

        // Jika struktur berbeda, coba langsung dari root
        if (responseData is Map && responseData.containsKey('id')) {
          print('Single menu found');
          return [Menu.fromJson(responseData)];
        }

        print('No menu found in expected format');
        return [];
      } else {
        throw Exception(
          'Gagal memuat data menu. Status: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error in getMenus: $e');
      throw Exception(
        'Gagal memuat data menu. Pastikan backend Laravel berjalan di $baseUrl',
      );
    }
  }

  // Delete menu (DELETE)
  Future<bool> deleteMenu(int id) async {
    try {
      print('Attempting to delete menu with ID: $id');
      print('URL: $baseUrl/$id');

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print('Menu deleted successfully');
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Gagal menghapus menu');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Menu tidak ditemukan');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Tidak memiliki izin untuk menghapus menu');
      } else {
        throw Exception('Gagal menghapus menu. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteMenu: $e');
      rethrow;
    }
  }

  // Create menu (CREATE)
  Future<bool> createMenu(Map<String, dynamic> data) async {
    try {
      print('Attempting to create menu');
      print('URL: $baseUrl');
      print('Data: $data');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('Create response status: ${response.statusCode}');
      print('Create response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print('Menu created successfully');
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Gagal membuat menu');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Tidak memiliki izin untuk membuat menu');
      } else {
        throw Exception('Gagal membuat menu. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createMenu: $e');
      rethrow;
    }
  }

  // Update menu (UPDATE)
  Future<bool> updateMenu(int id, Map<String, dynamic> data) async {
    try {
      print('Attempting to update menu with ID: $id');
      print('URL: $baseUrl/$id');
      print('Data: $data');

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print('Menu updated successfully');
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Gagal mengupdate menu');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Menu tidak ditemukan');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Tidak memiliki izin untuk mengupdate menu');
      } else {
        throw Exception(
          'Gagal mengupdate menu. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in updateMenu: $e');
      rethrow;
    }
  }
}
