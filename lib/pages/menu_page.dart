import 'package:flutter/material.dart';
import 'package:projeto_policia/components/botao_menu_component.dart';
import 'home_page.dart';
import 'tela_2.dart';
import 'tela_3.dart';
import 'tela_4.dart';

/// Tela inicial com menu de navegação
class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo/Título (Mantido igual)
        Icon(
          Icons.shield,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        const Text(
          'Polícia Científica',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Sistema de Ocorrências',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 48),

        // Grid de Botões
        GridView.count(
          shrinkWrap: true, // Importante para funcionar dentro de SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(), // Deixa o scroll apenas para o pai
          crossAxisCount: 2, // 2 botões por linha
          crossAxisSpacing: 16, // Espaço horizontal entre botões
          mainAxisSpacing: 16, // Espaço vertical entre botões
          childAspectRatio: 1.1, // Controla o quão "quadrado" o botão é (1.0 é um quadrado perfeito)
          children: [
            BotaoMenu(
              titulo: 'Ocorrências',
              icone: Icons.description,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage())),
            ),
            BotaoMenu(
              titulo: 'Tela 2',
              icone: Icons.people,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Tela2())),
            ),
            BotaoMenu(
              titulo: 'Tela 3',
              icone: Icons.settings,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Tela3())),
            ),
            BotaoMenu(
              titulo: 'Tela 4',
              icone: Icons.info,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Tela4())),
            ),
          ],
        ),
      ],
    ),
  ),
),      ),
    );
  }
}

