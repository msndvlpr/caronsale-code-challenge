import 'package:authentication_repository/authentication_repository.dart';
import 'package:caronsale_code_challenge/home/view/home_page.dart';
import 'package:caronsale_code_challenge/user_authentication/bloc/user_auth_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_lookup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAuthenticationScreen extends StatefulWidget {
  const UserAuthenticationScreen({super.key});

  @override
  _UserAuthenticationScreenState createState() => _UserAuthenticationScreenState();
}

class _UserAuthenticationScreenState extends State<UserAuthenticationScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Handle login
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      context.read<UserAuthBloc>().add(UserAuthDataFetched(username: username, password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserAuthBloc, UserAuthState>(
            listener: (context, state) {
              if (state is UserAuthDataStateSuccess) {
                _usernameController.clear();
                _passwordController.clear();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomePage(screen: 0)));

              } else if (state is UserAuthDataStateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
              }
            },
          ),
        ],
        child: BlocBuilder<UserAuthBloc, UserAuthState>(
          builder: (context, state) {

            var isLoading = false;
            if (state is UserAuthDataStateLoading) {
              isLoading = true;
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("User Authentication:", style: Theme.of(context).textTheme.headlineSmall),
                              SizedBox(height: 24,),
                              Text("You need to log in once, the next time you'll be signed in automatically.", style: Theme.of(context).textTheme.bodySmall),

                              const SizedBox(height: 26),
                              // Username Field
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => value!.isEmpty ? "Please enter your username" : null,
                              ),
                              const SizedBox(height: 15),
                              // Password Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary,),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).colorScheme.primary),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                              ),
                              const SizedBox(height: 20),
                              // Login Button
                              isLoading ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary) : ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text("Login", style: TextStyle(fontSize: 16)),
                              ),
                              const SizedBox(height: 10),
                              // Forgot Password
                              TextButton(
                                onPressed: () {},
                                child: Text("Forgot Password?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
