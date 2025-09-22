import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/auth/presentation/states/authentication_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(header: true, child: const Text('Home')),
        actions: [
          Semantics(
            button: true,
            hint: 'Logout from the application',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthenticationCubit>().logout();
              },
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Semantics(
                label: 'Home screen with user information and logout option',
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        label: 'User information card',
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Semantics(
                                  header: true,
                                  child: const Text(
                                    'Welcome!',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    semanticsLabel: 'Welcome - User greeting',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Semantics(
                                  label:
                                      'User phone number: ${state.user.phone}',
                                  child: Text(
                                    'Phone: ${state.user.phone}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Semantics(
                                  label: 'User ID: ${state.user.userId}',
                                  child: Text(
                                    'User ID: ${state.user.userId}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Semantics(
                        label: 'Login status information',
                        child: const Card(
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
                                  semanticsLabel:
                                      'You are successfully logged in to the application',
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'This is your home page.',
                                  style: TextStyle(fontSize: 14),
                                  semanticsLabel:
                                      'This is your home page where you can access app features',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Semantics(
                        button: true,
                        hint:
                            'Logout from the application and return to login screen',
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
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
                      ),
                    ],
                  ),
                ),
              );
            }

            return Semantics(
              label: 'Loading user data',
              child: const Center(
                child: Text(
                  'Loading user data...',
                  semanticsLabel: 'Loading user data, please wait',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
