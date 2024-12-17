import 'package:flutter/material.dart';
import 'package:iqurban/model/cow/cow_model.dart';
import 'package:iqurban/utils/database/database.dart';

class CowDescription extends StatelessWidget {
  final String cowId;

  const CowDescription({Key? key, required this.cowId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(title: const Text("Spesifikasi Hewan Kurban")),
      body: FutureBuilder<CowModel?>(
        future: getCowsData(cowId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data hewan kurban"));
          }

          final cow = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama: ${cow.name}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Umur: ${cow.age}", style: const TextStyle(fontSize: 16)),
                Text("Berat: ${cow.weight}kg", style: const TextStyle(fontSize: 16)),
                Text("Harga: Rp. ${cow.price}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text("Foto Wajah:", style: const TextStyle(fontSize: 16)),
                Image.network(
                  cow.faceImageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                const SizedBox(height: 8),
                Text("Foto Badan:", style: const TextStyle(fontSize: 16)),
                Image.network(
                  cow.bodyImageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                const SizedBox(height: 8),
                Text("Foto Kaki:", style: const TextStyle(fontSize: 16)),
                Image.network(
                  cow.feetImageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
