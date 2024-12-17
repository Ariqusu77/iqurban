import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';

import 'cow_page.dart';
import 'profile.dart';
import 'store_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String userId;
  late List<Widget> _widgetOptions;

  int _selectedPage = 0;

  @override
  void initState() {
    userId = context.read<AuthBloc>().currentUser!.uid;
    _widgetOptions = [
      CowPage(userId: userId),
      const StorePage(),
      ProfilePage(userId: userId),
    ];
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      body: _widgetOptions.elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Koleksi"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Pasar"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil"
          ),
        ]
      ),
    );
  }
}