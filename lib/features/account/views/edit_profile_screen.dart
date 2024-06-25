// lib/views/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  @override
  void initState() {
    super.initState();
    _controllers['name'] = TextEditingController(text: widget.userData['name']);
    _controllers['age'] =
        TextEditingController(text: widget.userData['age']?.toString());
    _controllers['phone'] =
        TextEditingController(text: widget.userData['phone']);
    _controllers['email'] =
        TextEditingController(text: widget.userData['email']);
    _controllers['password'] = TextEditingController();
    _controllers['confirmPassword'] = TextEditingController();

    _focusNodes['name'] = FocusNode();
    _focusNodes['age'] = FocusNode();
    _focusNodes['phone'] = FocusNode();
    _focusNodes['email'] = FocusNode();
    _focusNodes['password'] = FocusNode();
    _focusNodes['confirmPassword'] = FocusNode();

    _focusNodes.forEach((key, node) {
      node.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    _focusNodes.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
  }

  Color getLabelColor(FocusNode focusNode) {
    return focusNode.hasFocus
        ? const Color.fromARGB(255, 38, 87, 151)
        : Colors.grey;
  }

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
        title: Text(
          "Editar Perfil",
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            buildTextField('age', 'Idade'),
            const SizedBox(height: 10),
            buildTextField('phone', 'Telefone'),
            const SizedBox(height: 10),
            buildTextField('email', 'Email', readOnly: true),
            const SizedBox(height: 10),
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

                  await Provider.of<ProfileViewModel>(context, listen: false)
                      .updateProfile(
                    name: _controllers['name']!.text,
                    age: int.tryParse(_controllers['age']!.text),
                    phone: _controllers['phone']!.text,
                    password: _controllers['password']!.text.isNotEmpty
                        ? _controllers['password']!.text
                        : null,
                  );
                  Navigator.of(context).pop();
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