import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xfffee7c7),
      title: const Text("Lupa Password"),
      content: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: "Masukkan Email Anda",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  ForgotPasswordEvent(emailController.text.trim()),
                );
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
