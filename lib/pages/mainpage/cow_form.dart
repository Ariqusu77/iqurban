import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Add this dependency
import 'package:iqurban/model/cow/cow_model.dart';
import 'package:iqurban/model/cow/cow_bloc.dart';
import 'package:iqurban/model/cow/cow_event.dart';
import 'package:iqurban/model/auth/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCowForm extends StatefulWidget {
  @override
  _AddCowFormState createState() => _AddCowFormState();
}

class _AddCowFormState extends State<AddCowForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  File? faceImage;
  File? bodyImage;
  File? feetImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        switch (imageType) {
          case 'face':
            faceImage = File(pickedFile.path);
            break;
          case 'body':
            bodyImage = File(pickedFile.path);
            break;
          case 'feet':
            feetImage = File(pickedFile.path);
            break;
        }
      });
    }
  }

  Future<String> uploadProfilePicture(String path, String uid, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('$path/$uid.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Error uploading profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      appBar: AppBar(title: const Text('Tambahkan Hewan Kurban')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Hewan Kurban'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Umur Hewan Kurban (Bulan)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Berat Hewan Kurban (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => pickImage('face'),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Foto Bagian Kepala'),
              ),
              if (faceImage != null)
                Image.file(faceImage!, height: 100, width: 100, fit: BoxFit.cover),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => pickImage('body'),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Foto Bagian Badan'),
              ),
              if (bodyImage != null)
                Image.file(bodyImage!, height: 100, width: 100, fit: BoxFit.cover),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () => pickImage('feet'),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Foto Bagian Kaki'),
              ),
              if (feetImage != null)
                Image.file(feetImage!, height: 100, width: 100, fit: BoxFit.cover),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate inputs
                    if (nameController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        weightController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        faceImage == null ||
                        bodyImage == null ||
                        feetImage == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Isi semua data terlebih dahulu")),
                      );
                      return;
                    }

                    if (int.tryParse(ageController.text)! < 24) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Hewan Kurbanmu Terlalu Muda")),
                      );
                      return;
                    }

                    if (int.tryParse(weightController.text)! < 200){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Hewan Kurbanmu Terlalu Kurus")),
                      );
                      return;
                    }

                    final faceUrl = await uploadProfilePicture("face", userId, faceImage!);
                    final bodyUrl = await uploadProfilePicture("body", userId, bodyImage!);
                    final feetUrl = await uploadProfilePicture("feet", userId, feetImage!);
        
                    // Create a new CowModel
                    final cow = CowModel(
                      name: nameController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                      weight: double.tryParse(weightController.text) ?? 0.0,
                      price: int.tryParse(priceController.text) ?? 0,
                      faceImageUrl: faceUrl,
                      bodyImageUrl: bodyUrl,
                      feetImageUrl: feetUrl,
                    );
        
                    // Dispatch the event to save the cow
                    if (context.mounted){
                      context.read<CowBloc>().add(AddCowToUserEvent(userId: userId, cow: cow));
                    }
        
                    // Clear form fields
                    nameController.clear();
                    ageController.clear();
                    weightController.clear();
                    setState(() {
                      faceImage = null;
                      bodyImage = null;
                      feetImage = null;
                    });
        
                    // Navigate back or show success message
                    if (context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Hewan Kurban Berhasil Ditambahkan! Harap Refresh Halaman Utama")),
                      );
                    }
                  },
                  child: const Text('Tambahkan Hewan Kurban'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
