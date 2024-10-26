import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/LoginPage/bloc/login_bloc.dart';
import 'package:rideadmin/controller/auth_service.dart';
import 'package:rideadmin/drivers_list.dart/drivers.dart';
import 'package:rideadmin/profilePage/profile.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: BlocProvider(
              create: (context) =>LoginBloc(authService: AuthService()),
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoadedState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  DriverListScreen()),
                    );
                  } else if (state is ErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('cant login')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(child: Text('loading'));
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blueGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            ButtonClickedEvent(
                                username: usernameController.text,
                                password: passwordController.text),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[900],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      if (state is ErrorState)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            state.errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}