import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';
import 'package:iqurban/model/cow/cow_model.dart';
import 'package:iqurban/utils/database/database.dart';

import 'cow_desc.dart';

class CowCard extends StatelessWidget {
  final String cowId;

  const CowCard({Key? key, required this.cowId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().currentUser!.uid;
    return FutureBuilder<CowModel?>(
      future: getCowsData(cowId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text("Gagal memuat data hewan kurban"));
        }
        final cow = snapshot.data!;

        return FutureBuilder(
          future: getUserCows(userId), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text("Gagal memuat data hewan kurban"));
            }
            final myCows = snapshot.data!;
            
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Image.network(cow.faceImageUrl, fit: BoxFit.cover, width: 50, height: 50),
                title: Text(cow.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Umur: ${cow.age} bulan, Berat: ${cow.weight}kg"),
                    Text("Rp. ${cow.price}")
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CowDescription(cowId: cowId),
                    ),
                  );
                },

                trailing: myCows.contains(cowId) ? IconButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Hapus Hewan Kurban"),
                        content: const Text("Apakah Anda yakin ingin menghapus hewan kurban ini?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              deleteCow(userId, cowId);
                              Navigator.pop(context);
                            },
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete)) : null,
              ),
            );
          }
        );
      },
    );
  }
}
