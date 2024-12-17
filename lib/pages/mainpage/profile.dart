import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/cow/cow_bloc.dart';
import 'package:iqurban/model/cow/cow_event.dart';
import 'profile_card.dart';
import 'cow_list.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh the cow list for the user.
              context.read<CowBloc>().add(LoadUserCowsEvent(userId));
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                // Profile card section
                ProfileCard(userId: userId),
                const SizedBox(height: 20),
                // Section title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hewan Kurbanku',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                const SizedBox(height: 10),
                // Cow list with flexible layout
                Expanded(
                  child: CowList(userId: userId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
