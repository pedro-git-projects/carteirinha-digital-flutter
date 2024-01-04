import 'dart:convert';
import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:carteirinha_digital/state/user_type_provider.dart';
import 'package:carteirinha_digital/widgets/qr_code_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carteirinha_digital/state/storage_service.dart';
import 'package:carteirinha_digital/state/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController academicRegisterController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedUserType = "students";

  Future<void> _loginUser(BuildContext context) async {
    final userTypeProvider =
        Provider.of<UserTypeProvider>(context, listen: false);
    final academicRegister = academicRegisterController.text;
    final password = passwordController.text;

    if (academicRegister.isEmpty || password.isEmpty) {
      _showErrorSnackBar(context, "Preencha todos os campos!");
      return;
    }

    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;

    final storageService = Provider.of<StorageService>(context, listen: false);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final qrCodeManager = Provider.of<QRCodeManager>(context, listen: false);

    try {
      final userType = _selectedUserType;
      userTypeProvider.userType = userType;
      String firstField = "academic_register";
      if (userType == "parents") {
        firstField = "id";
      } else if (userType == "staff") {
        firstField = "chapa";
      }

      final requestBody = jsonEncode({
        firstField: academicRegister,
        "password": password,
      });

      final response = await http.post(
        Uri.parse('http://$ip:8080/auth/$userType/signin'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await storageService.write('token', token);
        if (!context.mounted) return;
        await qrCodeManager.downloadAndSaveQRCode(context);
        await authProvider.checkAuthentication();
      } else {
        final errorMessage = jsonDecode(response.body)['message'];
        debugPrint('Failed to login: $errorMessage');
        if (!context.mounted) return;
        _showErrorSnackBar(context, "Falha ao fazer login");
      }
    } catch (error) {
      if (!context.mounted) return;
      debugPrint(error.toString());
      _showErrorSnackBar(context, "Falha ao fazer login");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.orange,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors
                        .white // Change to your desired color for dark theme
                    : Colors
                        .black, // Change to your desired color for light theme
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/cnec-logo-branca.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
          TextFormField(
            controller: academicRegisterController,
            decoration: InputDecoration(
              labelText: _selectedUserType == "staff"
                  ? 'Chapa'
                  : (_selectedUserType == "parents"
                      ? 'ID'
                      : 'Registro Acadêmico'),
            ),
          ),
          //const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Senha',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
          ),
          const SizedBox(height: 16),
          const Text('Tipo de Usuário:'),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(
                  value: "students",
                  label: Text(
                    'Estudante',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  )),
              ButtonSegment<String>(
                  value: "parents",
                  label: Text(
                    'Responsável',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  )),
              ButtonSegment<String>(
                  value: "staff",
                  label: Text(
                    'Funcionário',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
            selected: <String>{_selectedUserType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedUserType = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loginUser(context),
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }
}
