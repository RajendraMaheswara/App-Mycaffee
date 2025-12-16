import 'package:flutter/material.dart';
import '../../services/menu_service.dart';
import '../../models/menu.dart';

class EditMenuPage extends StatefulWidget {
  final Menu menu;

  const EditMenuPage({super.key, required this.menu});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  late TextEditingController _namaController;
  late TextEditingController _kategoriController;
  late TextEditingController _stokController;
  late TextEditingController _hargaController;

  bool _isLoading = false;
  final MenuService _menuService = MenuService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.menu.nama);
    _kategoriController = TextEditingController(text: widget.menu.kategori);
    _stokController = TextEditingController(text: widget.menu.stok.toString());
    _hargaController = TextEditingController(
      text: widget.menu.harga.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> _updateMenu() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> updateData = {
        'nama_menu': _namaController.text,
        'kategori': _kategoriController.text,
        'stok': int.parse(_stokController.text),
        'harga': double.parse(_hargaController.text),
      };

      // Panggil service untuk update
      await _menuService.updateMenu(widget.menu.id, updateData);

      _showSnackBar('Menu berhasil diupdate!');

      // Kembali ke halaman menu
      if (!mounted) return;
      Navigator.pop(context, true); 
    } catch (e) {
      _showSnackBar('Gagal mengupdate menu: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5C4033),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF5C4033), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu'),
        backgroundColor: const Color(0xFF5C4033),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Menu
                    _buildTextField(
                      label: 'Nama Menu',
                      controller: _namaController,
                      hint: 'Contoh: Kopi Espresso',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama menu tidak boleh kosong';
                        }
                        return null;
                      },
                    ),

                    // Kategori
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5C4033),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _kategoriController.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kategori tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Pilih kategori',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF5C4033),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Snack',
                              child: Text('Snack'),
                            ),
                            DropdownMenuItem(
                              value: 'Makanan',
                              child: Text('Makanan'),
                            ),
                            DropdownMenuItem(
                              value: 'Kopi',
                              child: Text('Kopi'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _kategoriController.text = value;
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                    // Stok
                    _buildTextField(
                      label: 'Stok',
                      controller: _stokController,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Stok harus berupa angka';
                        }
                        return null;
                      },
                    ),

                    // Harga
                    _buildTextField(
                      label: 'Harga',
                      controller: _hargaController,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Harga harus berupa angka';
                        }
                        return null;
                      },
                    ),

                    // Tombol Update
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C4033),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Update Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tombol Batal
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF5C4033),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(
                            color: Color(0xFF5C4033),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
