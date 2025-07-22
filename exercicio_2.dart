import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(
    home: EmailSenhaForm(),
    debugShowCheckedModeBanner: false,
  ));
}

class EmailSenhaForm extends StatefulWidget {
  const EmailSenhaForm({super.key});

  @override
  State<EmailSenhaForm> createState() => _EmailSenhaFormState();
}

class _EmailSenhaFormState extends State<EmailSenhaForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  // Campos de exibição após envio
  String emailEnviado = '';
  String senhaEnviada = '';
  String notaSenha = '';

  // Regex para entrada de email permitida: letras, números, @ e ponto
  final RegExp _emailInputRegex = RegExp(r'[a-zA-Z0-9@.]');
  final RegExp _emailValidatorRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Valida se senha tem ao menos uma letra e um número
  bool _senhaValida(String senha) {
    return RegExp(r'[a-zA-Z]').hasMatch(senha) && RegExp(r'\d').hasMatch(senha);
  }

  // Calcula a força da senha com base nos critérios
  String _avaliarForcaSenha(String senha) {
    int pontos = 0;

    // Pontos por comprimento
    if (senha.length >= 12) {
      pontos += 3;
    } else if (senha.length >= 10) {
      pontos += 2;
    } else if (senha.length >= 8) {
      pontos += 1;
    }

    // Pontos por variedade de tipos
    int tipos = 0;
    if (RegExp(r'[a-z]').hasMatch(senha)) tipos++;
    if (RegExp(r'[A-Z]').hasMatch(senha)) tipos++;
    if (RegExp(r'\d').hasMatch(senha)) tipos++;
    if (RegExp(r'[!@#\$%^&*.,]').hasMatch(senha)) tipos++;

    pontos += tipos;

    // Frase de retorno conforme pontuação
    if (pontos <= 4) return 'Essa senha é mais fácil que 123456';
    if (pontos <= 6) return 'Tá no meio do caminho entre 123456 e 86EdC7S*]!N9';
    return 'Essa senha é braba! Nem o FBI quebra!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulário Email e Senha")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email é obrigatório';
                  if (!_emailValidatorRegex.hasMatch(value)) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Senha
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Senha é obrigatória';
                  if (value.length < 8) return 'Senha deve ter pelo menos 8 caracteres';
                  if (value.length > 16) return 'Senha não pode ter mais de 16 caracteres';
                  if (!_senhaValida(value)) return 'A senha deve conter pelo menos uma letra e um número';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Botão de Enviar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      emailEnviado = _emailController.text;
                      senhaEnviada = _senhaController.text;
                      notaSenha = _avaliarForcaSenha(_senhaController.text);
                    });
                  }
                },
                child: const Text('Enviar'),
              ),

              const SizedBox(height: 30),

              // Campos de texto exibindo os resultados
              Text("Email enviado: $emailEnviado"),
              const SizedBox(height: 10),
              Text("Senha enviada: $senhaEnviada"),
              const SizedBox(height: 10),
              Text("Força da senha: $notaSenha", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
