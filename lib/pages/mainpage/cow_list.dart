import 'package:flutter/material.dart';
import 'package:iqurban/utils/database/database.dart'; // Replace with the path to your Firestore functions
import 'cow_card.dart'; // Replace with the path to your CowCard widget

class CowList extends StatelessWidget {
  final String userId;

  const CowList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getUserCows(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada data hewan kurban"));
        }

        final cowIds = snapshot.data!;

        return ListView.builder(
          itemCount: cowIds.length,
          itemBuilder: (context, index) {
            return CowCard(cowId: cowIds[index]);
          },
        );
      },
    );
  }
}
