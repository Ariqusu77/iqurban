import 'package:flutter/material.dart';
import 'cow_form.dart';
import 'cow_list.dart';

class CowPage extends StatefulWidget {
  final String userId; // The user's ID to fetch owned cows.

  const CowPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<CowPage> createState() => _CowPageState();
}

class _CowPageState extends State<CowPage> {

  void _refresh(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(
        title: const Text('Hewan Kurbanku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CowList(userId: widget.userId), // Display list of owned cows.
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddCowForm.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddCowForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambahkan Hewan Kurban',
      ),
    );
  }
}
