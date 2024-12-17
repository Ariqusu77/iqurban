import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';
import 'package:iqurban/model/cow/cow_bloc.dart';
import 'package:iqurban/model/cow/cow_event.dart';
import 'package:iqurban/model/cow/cow_state.dart';
import 'profile_card.dart';
import 'cow_list.dart';

class StorePage extends StatelessWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myUserId = context.read<AuthBloc>().currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(
        title: const Text('Pasar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CowBloc>().add(const LoadUserWithCows());
            },
          ),
        ],
      ),
      body: BlocBuilder<CowBloc, CowState>(
        builder: (context, state) {
          if (state is CowLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CowError) {
            return Center(child: Text(state.message));
          } else if (state is CowLoaded) {
            List<String> marketUser = List.from(state.usersCows);
            marketUser.remove(myUserId);
            if (marketUser.isEmpty) {
              return const Center(child: Text('Belum Ada Penjual'));
            }

            return ListView.builder(
              itemCount: marketUser.length,
              itemBuilder: (context, index) {
                final userId = marketUser[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      child: ProfileCard(userId: userId),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => 
                            Scaffold(
                              backgroundColor: const Color(0xfffee7c7),
                              appBar: AppBar(
                                title: const Text("List Hewan Kurban")
                              ),
                              body: CowList(userId: userId),
                            )
                          )
                        );
                      },
                    )// Display user profile.
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Belum Ada Data Tersedia'));
        },
      ),
    );
  }
}
