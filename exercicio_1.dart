import 'package:flutter/material.dart';          // Biblioteca para componentes visuais do Flutter
import 'package:flutter/services.dart';         // Biblioteca para usar inputFormatters (filtros de entrada)

void main() {
  runApp(const MyApp());                        // Função principal que inicia o app chamando MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Estrutura principal do app
    return MaterialApp(
      title: 'Nickname Formulário',             // Título do app
      home: Scaffold(                           // Estrutura da tela principal
        appBar: AppBar(title: const Text('Cadastro')),  // Barra superior com título
        body: const Padding(
          padding: EdgeInsets.all(16.0),        // Espaçamento interno
          child: NicknameForm(),                // Widget que contém o formulário do nickname
        ),
      ),
    );
  }
}

class NicknameForm extends StatefulWidget {
  const NicknameForm({super.key});

  @override
  State<NicknameForm> createState() => _NicknameFormState();
}

class _NicknameFormState extends State<NicknameForm> {
  // Chave global para validar o formulário
  final _formKey = GlobalKey<FormState>();

  // Controlador para acessar o conteúdo do TextFormField
  final TextEditingController _nicknameController = TextEditingController();

  // Expressão regular para validar o nickname (letras, números, _ . -)
  final _nicknameRegex = RegExp(r'^[a-zA-Z0-9_.-]+$');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,  // Chave do formulário para validação
      child: Column(
        children: [
          // Campo de texto para o nickname
          TextFormField(
            controller: _nicknameController,  // Conecta o campo ao controlador
            decoration: const InputDecoration(
              labelText: 'Nickname',          // Rótulo visível acima do campo
              hintText: 'Digite seu nickname', // Texto de dica
              border: OutlineInputBorder(),   // Borda do campo
            ),
            // Filtro para permitir apenas letras, números, underline, ponto e hífen
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.-]')),
            ],
            // Função de validação chamada ao enviar o formulário
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O nickname é obrigatório'; // Campo vazio
              }
              if (!_nicknameRegex.hasMatch(value)) {
                return 'Nickname inválido. Use apenas letras, números, "_", "-" ou "."';
              }
              return null; // Se tudo estiver certo
            },
          ),
          const SizedBox(height: 20), // Espaçamento entre o campo e o botão
          
          // Botão de envio do formulário
          ElevatedButton(
            onPressed: () {
              // Se o formulário for válido, mostra uma mensagem com o nickname
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nickname válido: ${_nicknameController.text}')),
                );
              }
            },
            child: const Text('Enviar'), // Texto do botão
          ),
        ],
      ),
    );
  }
}
