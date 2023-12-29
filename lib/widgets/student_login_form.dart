import 'dart:convert';
import 'package:carteirinha_digital/state/config_provider.dart';
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

  Future<void> _loginUser(BuildContext context) async {
    final academicRegister = academicRegisterController.text;
    final password = passwordController.text;

    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;

    final storageService = Provider.of<StorageService>(context, listen: false);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final requestBody = jsonEncode({
      "academic_register": academicRegister,
      "password": password,
    });

    print('REQUEST BODY: $requestBody !!!!');

    final response = await http.post(
      Uri.parse('http://$ip:8080/auth/students/signin'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    print('RESPONSE: $response !!!!');

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await storageService.write('token', token);
      await authProvider.checkAuthentication();
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      print('Failed to login: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: academicRegisterController,
            decoration: const InputDecoration(
              labelText: 'Registro Acadêmico',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Senha',
            ),
            obscureText: true,
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
