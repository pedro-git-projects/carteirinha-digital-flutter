import 'dart:convert';

import 'package:carteirinha_digital/state/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class RecoverAccountForm extends StatefulWidget {
  const RecoverAccountForm({super.key});

  @override
  State<RecoverAccountForm> createState() => _RecoverAccountFormState();
}

class _RecoverAccountFormState extends State<RecoverAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(''),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _recoverAccount() async {
    final email = emailController.text;

    final config = Provider.of<ConfigProvider>(context, listen: false);
    final ip = config.ip;

    final requestBody = jsonEncode({
      "email": email,
    });

    print(requestBody);

    final response = await http.post(
      Uri.parse('http://$ip:3000/auth/recovery'),
      headers: {'Cotent-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 202) {
      final token = jsonDecode(response.body)['message'];
      _showMessageDialog(token);
    } else {
      final errorMessage = jsonDecode(response.body)['message'];
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email para recurperação",
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Por favor um email';
                }
                return null;
              }),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _recoverAccount,
                child: const Text("Recuperar"),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
