// lib/views/signup_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/signup_viewmodel.dart';
import 'login_screen.dart';

/// Classe que define a tela de cadastro como um StatefulWidget.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

/// Classe de estado para SignupScreen que mantém o estado dos campos de texto e nós de foco.
class _SignupScreenState extends State<SignupScreen> {
  // Controladores para os campos de texto.
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  // Nós de foco para os campos de texto.
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  // Variável para indicar o estado de carregamento.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Adiciona listeners para mudanças no foco dos campos de texto.
    nameFocusNode.addListener(_onFocusChange);
    emailFocusNode.addListener(_onFocusChange);
    phoneFocusNode.addListener(_onFocusChange);
    ageFocusNode.addListener(_onFocusChange);
    passwordFocusNode.addListener(_onFocusChange);
    confirmPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Remove listeners e descarta os nós de foco ao finalizar.
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    ageFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  /// Função para lidar com mudanças de foco nos campos de texto.
  void _onFocusChange() {
    setState(() {});
  }

  /// Função para obter a cor do ícone com base no foco do campo.
  Color getIconColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cria uma instância de SignupViewModel.
      create: (context) => SignupViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastre-se'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo da aplicação.
                SizedBox(
                  child: Image.asset('lib/assets/images/logo2.png', width: 90),
                ),
                // Campo de texto para o nome.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                // Campo de texto para o email.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                // Campo de texto para o contato.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                // Campo de texto para a idade.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                // Campo de texto para a senha.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: password,
                    focusNode: passwordFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        'Senha',
                        style:
                            TextStyle(color: getIconColor(passwordFocusNode)),
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
                // Campo de texto para confirmar a senha.
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: confirmpassword,
                    obscureText: true,
                    focusNode: confirmPasswordFocusNode,
                    decoration: InputDecoration(
                      label: Text(
                        'Repita sua senha',
                        style: TextStyle(
                            color: getIconColor(confirmPasswordFocusNode)),
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
                // Botão de cadastro com comportamento condicionado ao estado de carregamento.
                Consumer<SignupViewModel>(
                  builder: (context, viewModel, child) {
                    return Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 38, 87, 151)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(15)),
                        ),
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                // Verifica se as senhas coincidem.
                                if (password.text != confirmpassword.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('As senhas não coincidem'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                // Tenta realizar o cadastro com os dados fornecidos.
                                bool success = await viewModel.register(
                                  email.text,
                                  password.text,
                                  name.text,
                                  phone.text,
                                  int.parse(age.text),
                                );

                                setState(() {
                                  isLoading = false;
                                });

                                // Verifica se o cadastro foi bem-sucedido.
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Usuário cadastrado com sucesso'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Navega para a tela de login em caso de sucesso.
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Por favor, preencha os campos corretamente'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
