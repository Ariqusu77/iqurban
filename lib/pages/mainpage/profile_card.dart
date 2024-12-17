import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';
import 'package:iqurban/utils/database/database.dart';
import 'package:iqurban/pages/auth/auth_edit.dart';

class ProfileCard extends StatelessWidget {
  final String userId;

  const ProfileCard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myUserId = context.read<AuthBloc>().currentUser!.uid;
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text("Failed to load user data"));
        }

        final userData = snapshot.data!;
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(6),
          child: GestureDetector(
            onTap: () {
              myUserId == userId 
              ? Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => EditProfilePage()
                )
              ) 
              :null;
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Image.network(
                      userData["profile_picture_url"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${userData['name'].toString().length > 12 ? userData['name'].toString().substring(0,12) : userData['name']}", style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis,),
                      Text("Domisili: ${userData['domisili']}", style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,),
                      Text("Whatsapp: ${userData['wa']}", style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
