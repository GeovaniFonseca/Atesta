// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, file_names, use_key_in_widget_constructors, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../../services/DatabaseService.dart';
import '../../core/start_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email =
      TextEditingController(); //controlado a entrada de dados.
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
      // Se algum campo tem foco, atualiza o estado para refletir a cor nova
      setState(() {});
    }
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus ? Color.fromARGB(255, 38, 87, 151) : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset('lib/assets/images/logo2.png', width: 100),
          ),
          Container(
            padding: EdgeInsets.all(10),
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
                      fontWeight: FontWeight.w400),
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
                setState(
                    () {}); // Chama setState para atualizar a cor do ícone quando o campo ganha foco
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
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
                      fontWeight: FontWeight.w400),
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
                setState(
                    () {}); // Chama setState para atualizar a cor do ícone quando o campo ganha foco
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                var checklogin = await login(email.text, password.text);
                if (checklogin == true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Login efetuado com sucessso'),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Start(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Email ou senha incorretos.'),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 38, 87, 151)), // Cor de fundo do botão
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Raio do canto arredondado
                  ),
                ),
                padding: MaterialStateProperty.all(
                    EdgeInsets.all(15)), // Padding interno do botão
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white, // Cor do texto
                  fontWeight: FontWeight.bold, // Negrito
                  fontSize: 16, // Tamanho do texto
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupScreen(),
                ),
              );
            },
            child: Text('Cadastre-se',
                style: TextStyle(color: Color.fromARGB(255, 38, 87, 151))),
          )
        ],
      ),
    );
  }
}
