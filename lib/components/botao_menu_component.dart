import 'package:flutter/material.dart';

/// Widget reutilizável para botão do menu
class BotaoMenu extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onPressed;

  const BotaoMenu({super.key, 
    required this.titulo,
    required this.icone,
    this.cor = const Color.fromARGB(255, 67, 155, 70),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Material(
        color: cor.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  icone,
                  size: 32,
                  color: cor,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: cor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: cor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
