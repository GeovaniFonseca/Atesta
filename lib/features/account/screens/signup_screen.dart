// ignore_for_file: use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../services/DatabaseService.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Adicione os ouvintes de foco aqui
    nameFocusNode.addListener(_onFocusChange);
    emailFocusNode.addListener(_onFocusChange);
    phoneFocusNode.addListener(_onFocusChange);
    ageFocusNode.addListener(_onFocusChange);
    passwordFocusNode.addListener(_onFocusChange);
    confirmPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Não esqueça de limpar os FocusNodes
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    ageFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus ? Color.fromARGB(255, 38, 87, 151) : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastre-se'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('lib/assets/images/logo2.png', width: 100),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: name,
                focusNode: nameFocusNode,
                decoration: InputDecoration(
                  label: Text(
                    'Nome',
                    style: TextStyle(
                      color: getIconColor(nameFocusNode),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: email,
                focusNode: emailFocusNode,
                decoration: InputDecoration(
                  label: Text(
                    'Email',
                    style: TextStyle(
                      color: getIconColor(emailFocusNode),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: phone,
                focusNode: phoneFocusNode,
                decoration: InputDecoration(
                  label: Text(
                    'Contato',
                    style: TextStyle(color: getIconColor(phoneFocusNode)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: age,
                focusNode: ageFocusNode,
                decoration: InputDecoration(
                  label: Text(
                    'Idade',
                    style: TextStyle(color: getIconColor(ageFocusNode)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: password,
                focusNode: passwordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  label: Text(
                    'Senha',
                    style: TextStyle(color: getIconColor(passwordFocusNode)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: confirmpassword,
                obscureText: true,
                focusNode: confirmPasswordFocusNode,
                decoration: InputDecoration(
                  label: Text(
                    'Reptira sua senha',
                    style: TextStyle(color: getIconColor(confirmPasswordFocusNode)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 38, 87, 151),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await register(email.text, password.text, name.text,
                              phone.text, int.parse(age.text));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuário cadastrado com sucesso'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Falha ao cadastrar usuário: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Cadastrar',
                        style: TextStyle(fontSize: 20, height: 2),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
