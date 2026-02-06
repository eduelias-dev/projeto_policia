import 'package:flutter/material.dart';
import 'package:projeto_policia/models/ocorrencias.dart';

/// Widget que exibe o cartão de uma ocorrência
class CartaoOcorrencia extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final VoidCallback onDelete;

  const CartaoOcorrencia({
    required this.ocorrencia,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.blue),
        title: Text(
          ocorrencia.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              ocorrencia.descricao,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              ocorrencia.data,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
        isThreeLine: true,
      ),
    );
  }
}