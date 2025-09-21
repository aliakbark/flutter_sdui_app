import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Phone: ${state.user.phone}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'User ID: ${state.user.userId}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You are successfully logged in!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'This is your home page.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationCubit>().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Loading user data...'));
        },
      ),
    );
  }
}
