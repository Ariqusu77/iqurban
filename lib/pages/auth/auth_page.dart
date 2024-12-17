import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqurban/model/auth/auth.dart';

import 'auth_form.dart';
import 'auth_forgot.dart';
import 'package:iqurban/pages/mainpage/main_page.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffee7c7),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          } else if (state is AuthSignedIn) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => FormPage())
            );
          } else if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading || state is ForgotPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/mobprog-c692c.firebasestorage.app/o/Brown%20Illustrative%20Eid%20Al%20Adha%20Presentation%20(1)%202.png?alt=media&token=ced74400-42ca-422e-8d6d-ce4ed9d7d48c",
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          SignInEvent(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                  },
                  child: const Text('Registrasi'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          LogInEvent(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                  },
                  child: const Text('Log In'),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ForgotPasswordDialog(),
                    );
                  },
                  child: const Text("Lupa Password?"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


