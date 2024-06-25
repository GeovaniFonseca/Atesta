// lib/views/login_screen.dart
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_screen.dart';
import '../viewmodels/login_viewmodel.dart';
import '../../navigation/bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (emailFocusNode.hasFocus || passwordFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset('lib/assets/images/logo2.png', width: 100),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: email,
                    focusNode: emailFocusNode,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined,
                          color: getIconColor(emailFocusNode)),
                      label: Text(
                        'Email',
                        style: TextStyle(
                          color: getIconColor(emailFocusNode),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 38, 87, 151),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: password,
                    focusNode: passwordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline,
                          color: getIconColor(passwordFocusNode)),
                      label: Text(
                        'Senha',
                        style: TextStyle(
                          color: getIconColor(passwordFocusNode),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 38, 87, 151),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onTap: () {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            try {
                              bool success = await viewModel.login(
                                  email.text, password.text);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login efetuado com sucesso'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigation(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email ou senha incorretos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Ocorreu um erro. Tente novamente.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 38, 87, 151)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(color: Color.fromARGB(255, 38, 87, 151)),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
