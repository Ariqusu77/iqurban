import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iqurban/model/auth/auth_bloc.dart';
import 'package:iqurban/model/auth/auth_event.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController domisiliController = TextEditingController();
  final TextEditingController waController = TextEditingController();
  File? profilePicture;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final userData = authBloc.userData;

    nameController.text = userData?['name'] ?? '';
    ageController.text = userData?['age']?.toString() ?? '';
    domisiliController.text = userData?['domisili'] ?? '';
    waController.text = userData?['wa'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    profilePicture = File(pickedFile.path);
                  });
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profilePicture != null
                    ? FileImage(profilePicture!)
                    : NetworkImage(userData?['profile_picture_url'] ?? '') as ImageProvider,
                child: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Umur"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: domisiliController,
              decoration: const InputDecoration(labelText: "Domisili"),
            ),
            TextField(
              controller: waController,
              decoration: const InputDecoration(labelText: "Nomer Whatsapp"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final updatedData = {
                  'name': nameController.text,
                  'age': int.tryParse(ageController.text),
                  'domisili': domisiliController.text,
                  'wa': waController.text,
                  'profile_picture': profilePicture?.path,
                };
                authBloc.add(EditProfileEvent(updatedData));
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
