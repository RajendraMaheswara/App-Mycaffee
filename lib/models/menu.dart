class Menu {
  final int id;
  final String nama;
  final String kategori;
  final int stok;
  final double harga;
  final String gambar;

  Menu({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.stok,
    required this.harga,
    required this.gambar,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      nama: json['nama_menu'],
      kategori: json['kategori'],
      stok: json['stok'],
      harga: double.parse(json['harga']),
      gambar: json['gambar'],
    );
  }
}