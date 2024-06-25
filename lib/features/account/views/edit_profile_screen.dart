// lib/views/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../navigation/bottom_navigation.dart';
import '../viewmodels/profile_viewmodel.dart';

/// Classe que define a tela de edição do perfil como um StatefulWidget.
class EditProfileScreen extends StatefulWidget {
  // Dados do usuário passados para a tela.
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

/// Classe de estado para EditProfileScreen que mantém o estado dos campos de texto e nós de foco.
class _EditProfileScreenState extends State<EditProfileScreen> {
  // Mapas para os controladores de texto e nós de foco.
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    // Inicializa os controladores de texto com os dados do usuário.
    _controllers['name'] = TextEditingController(text: widget.userData['name']);
    _controllers['age'] =
        TextEditingController(text: widget.userData['age']?.toString());
    _controllers['phone'] =
        TextEditingController(text: widget.userData['phone']);
    _controllers['email'] =
        TextEditingController(text: widget.userData['email']);
    _controllers['password'] = TextEditingController();
    _controllers['confirmPassword'] = TextEditingController();

    // Inicializa os nós de foco para cada campo.
    _focusNodes['name'] = FocusNode();
    _focusNodes['age'] = FocusNode();
    _focusNodes['phone'] = FocusNode();
    _focusNodes['email'] = FocusNode();
    _focusNodes['password'] = FocusNode();
    _focusNodes['confirmPassword'] = FocusNode();

    // Adiciona listeners aos nós de foco para atualizar a UI quando o foco mudar.
    _focusNodes.forEach((key, node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    // Descarta os controladores de texto e nós de foco ao finalizar.
    _controllers.forEach((_, controller) => controller.dispose());
    _focusNodes.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
  }

  /// Retorna a cor do rótulo com base no foco do campo.
  Color getLabelColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

  /// Constrói um campo de texto com as propriedades fornecidas.
  Widget buildTextField(String key, String label,
      {bool readOnly = false, bool obscureText = false}) {
    return TextFormField(
      controller: _controllers[key],
      focusNode: _focusNodes[key],
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: getLabelColor(_focusNodes[key]!)),
        floatingLabelStyle: TextStyle(color: getLabelColor(_focusNodes[key]!)),
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
      keyboardType: key == 'age' ? TextInputType.number : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          "Editar Perfil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('name', 'Nome'),
            const SizedBox(height: 10),
            buildTextField('email', 'Email', readOnly: true),
            const SizedBox(height: 10),
            buildTextField('age', 'Idade'),
            const SizedBox(height: 10),
            buildTextField('phone', 'Telefone'),
            const SizedBox(height: 10),
            const Row(
              children: [
                Padding(padding: EdgeInsets.all(4)),
                Text(
                  "Redefinir senha",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
            const SizedBox(height: 5),
            buildTextField('password', 'Senha', obscureText: true),
            const SizedBox(height: 10),
            buildTextField('confirmPassword', 'Confirmar Senha',
                obscureText: true),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 150,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 38, 87, 151)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () async {
                  // Verifica se as senhas inseridas coincidem
                  if (_controllers['password']!.text !=
                      _controllers['confirmPassword']!.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('As senhas não coincidem'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Atualiza o perfil do usuário com os novos dados
                  await Provider.of<ProfileViewModel>(context, listen: false)
                      .updateProfile(
                    name: _controllers['name']!.text,
                    age: int.tryParse(_controllers['age']!.text),
                    phone: _controllers['phone']!.text,
                    password: _controllers['password']!.text.isNotEmpty
                        ? _controllers['password']!.text
                        : null,
                  );
                  // Navega de volta para a tela principal após a atualização
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigation()),
                  );
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
