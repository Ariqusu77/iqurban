import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iqurban/model/auth/auth.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController domisiliController = TextEditingController();
  File? profilePicture;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(title: const Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Name input
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 16),

              // Age input
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Umur'),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nomor WhatsApp'),
              ),
              const SizedBox(height: 16),

              // Domisili input
              TextField(
                controller: domisiliController,
                decoration: const InputDecoration(labelText: 'Domisili'),
              ),
              const SizedBox(height: 16),

              // Profile picture
              Row(
                children: [
                  profilePicture != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(profilePicture!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text('Upload Foto Profil'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      numberController.text.isNotEmpty &&
                      domisiliController.text.isNotEmpty &&
                      profilePicture != null) {
                    context.read<AuthBloc>().add(
                          SubmitFormEvent({
                            'name': nameController.text,
                            'age': ageController.text,
                            'wa' : numberController.text,
                            'domisili': domisiliController.text,
                            'profile_picture': profilePicture!.path,
                          }),
                        );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Isi semua data diri beserta foto profil terlebih dahulu'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
